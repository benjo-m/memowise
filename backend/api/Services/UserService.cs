using api.Data;
using api.DTO;
using api.Exceptions;
using api.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using RegisterRequest = api.DTO.RegisterRequest;

namespace api.Services;

public class UserService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public UserService(ApplicationDbContext dbContext, IHttpContextAccessor httpContextAccessor)
    {
        _dbContext = dbContext;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<User?> GetAchievementsByUser(int userId)
    {
        return await _dbContext.Users
            .Include(u => u.Achievements)
            .SingleOrDefaultAsync(u => u.Id == userId);
    }

    public async Task<UserDto?> Login(LoginRequest loginRequest)
    {
        var user = await _dbContext.Users
            .Where(u => u.Username == loginRequest.Username)
            .FirstOrDefaultAsync();

        if (user == null || !BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.PasswordHashed)) 
        {
            return null;
        }

        var userDto = new UserDto(user);

        return userDto;
    }
    
    public async Task<UserDto?> Register(RegisterRequest registerRequest)
    {
        if (registerRequest.Password != registerRequest.PasswordConfirmation)
        {
            throw new PasswordsNotMatchingException("Passwords do not match");
        }

        if (await _dbContext.Users.AnyAsync(u => u.Username == registerRequest.Username))
        {
            throw new UsernameTakenException("Username taken");
        }

        if (await _dbContext.Users.AnyAsync(u => u.Email == registerRequest.Email))
        {
            throw new EmailAlreadyInUseException("Email already in use");
        }

        var user = new User(registerRequest);

        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();

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
            .FirstOrDefaultAsync(u => u.Id == int.Parse(userId));

        return user;
    }
}
