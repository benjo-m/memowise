using api.Data;
using MemoWise.Model.DTO;
using api.Exceptions;
using MemoWise.Model.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using RabbitMQ.Client;
using System.Text;
using System.Text.Json;

namespace api.Services;

public class AuthService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IConfiguration _configuration;

    public AuthService(ApplicationDbContext dbContext, IHttpContextAccessor httpContextAccessor, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _httpContextAccessor = httpContextAccessor;
        _configuration = configuration;
    }

    public async Task<UserDto?> Login(LoginRequest loginRequest)
    {
        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .Where(u => u.Username == loginRequest.Username)
            .FirstOrDefaultAsync();

        if (user == null || !BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.PasswordHashed))
        {
            return null;
        }

        await CheckStudyStreak(user);

        var userDto = new UserDto(user);

        await SaveLoginRecord(user.Id);

        return userDto;
    }

    public async Task<UserDto?> Register(RegisterRequest registerRequest)
    {
        await ValidateRegisterRequest(registerRequest);

        var user = new User(registerRequest);

        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();

        await SendQueueMessage(user);

        return new UserDto(user);
    }

    public async Task<User?> GetCurrentUser()
    {
        var userId = _httpContextAccessor.HttpContext!.User
            .FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (userId == null)
        {
            return null;
        }

        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .Include(u => u.Achievements)
            .SingleOrDefaultAsync(u => u.Id == int.Parse(userId));

        return user;
    }

    private async Task CheckStudyStreak(User user)
    {
        var lastStudySession = await _dbContext.StudySessions
            .Where(ss => ss.UserId == user.Id)
            .OrderByDescending(ss => ss.StudiedAt)
            .FirstOrDefaultAsync();

        if (lastStudySession != null && lastStudySession.StudiedAt.Date < DateTime.Now.Date.AddDays(-1))
        {
            user.UserStats.StudyStreak = 0;

            _dbContext.Users.Update(user);
            await _dbContext.SaveChangesAsync();
        }
    }
    private async Task SaveLoginRecord(int userId)
    {
        var loginRecord = new LoginRecord()
        {
            UserId = userId,
            LoginDateTime = DateTime.Now
        };

        _dbContext.LoginRecords.Add(loginRecord);
        await _dbContext.SaveChangesAsync();
    }

    private async Task ValidateRegisterRequest(RegisterRequest registerRequest)
    {
        if (registerRequest.Password != registerRequest.PasswordConfirmation)
        {
            throw new PasswordsNotMatchingException("Passwords do not match");
        }

        if (await _dbContext.Users.AnyAsync(u => u.Username == registerRequest.Username))
        {
            throw new DuplicateEntryException("USERNAME_TAKEN", "Username taken");
        }

        if (await _dbContext.Users.AnyAsync(u => u.Email == registerRequest.Email))
        {
            throw new DuplicateEntryException("EMAIL_TAKEN", "Email already in use");
        }
    }

    private async Task SendQueueMessage(User user)
    {
        var emailRecipient = new EmailRecipient
        {
            Email = user.Email,
            Username = user.Username,
        };

        var rabbitMqHost = _configuration["RABBITMQ_HOST"] ?? "localhost";
        var rabbitMqPort = _configuration["RABBITMQ_PORT"] ?? "5672";
        var rabbitMqUser = _configuration["RABBITMQ_DEFAULT_USER"] ?? "guest";
        var rabbitMqPass = _configuration["RABBITMQ_DEFAULT_PASS"] ?? "guest";
        var rabbitMqQueue = _configuration["RABBITMQ_QUEUE"] ?? "email";

        var factory = new ConnectionFactory 
        { 
            HostName = rabbitMqHost,
            Port = int.Parse(rabbitMqPort),
            UserName = rabbitMqUser,
            Password = rabbitMqPass
        };
        using var connection = await factory.CreateConnectionAsync();
        using var channel = await connection.CreateChannelAsync();

        await channel.QueueDeclareAsync(queue: rabbitMqQueue, durable: false, exclusive: false, autoDelete: false,
            arguments: null);

        var recipient = new EmailRecipient
        {
            Email = user.Email,
            Username = user.Username,
        };

        var json = JsonSerializer.Serialize(recipient);
        var body = Encoding.UTF8.GetBytes(json);

        await channel.BasicPublishAsync(exchange: string.Empty, routingKey: rabbitMqQueue, body: body);
    }

}
