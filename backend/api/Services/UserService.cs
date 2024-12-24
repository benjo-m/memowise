using api.Data;
using api.DTO;
using api.Exceptions;
using api.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using LoginRequest = api.DTO.LoginRequest;
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

    public async Task UpdateUser(UpdateUserRequest updateUserRequest)
    {
        var user = await GetCurrentUser();

        if (user == null)
        {
            return;
        }

        bool isUsernameTaken = await _dbContext.Users.AnyAsync(u => u.Username == updateUserRequest.Username);
        bool isEmailTaken = await _dbContext.Users.AnyAsync(u => u.Email == updateUserRequest.Email);

        if (isUsernameTaken && user.Username != updateUserRequest.Username)
        {
            throw new UsernameTakenException("Username taken");
        }

        if (isEmailTaken && user.Email != updateUserRequest.Email)
        {
            throw new EmailAlreadyInUseException("Email already in use");
        }
        
        user.Username = updateUserRequest.Username;
        user.Email = updateUserRequest.Email;
        
        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task ChangePassword(ChangePasswordRequest changePasswordRequest)
    {
        var user = await GetCurrentUser();

        if (user == null || !BCrypt.Net.BCrypt.Verify(changePasswordRequest.CurrentPassword, user.PasswordHashed))
        {
            throw new WrongPasswordException("Wrong Password");
        }

        if (changePasswordRequest.CurrentPassword == changePasswordRequest.NewPassword)
        {
            return;
        }

        user.PasswordHashed = BCrypt.Net.BCrypt.HashPassword(changePasswordRequest.NewPassword);

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteUser(DeleteUserRequest deleteUserRequest)
    {
        var user = await GetCurrentUser();

        if (user == null || !BCrypt.Net.BCrypt.Verify(deleteUserRequest.Password, user.PasswordHashed))
        {
            throw new WrongPasswordException("Wrong Password");
        }

        _dbContext.Users.Remove(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAllData()
    {
        var user = await GetCurrentUser();

        if (user == null)
        {
            return;
        }

        ResetUserStats(user);

        var decks = await _dbContext.Decks
            .Where(d => d.UserId == user.Id)
            .ToListAsync();

        await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM AchievementUser WHERE UsersId = {0}", user.Id);

        _dbContext.Decks.RemoveRange(decks);
        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    private void ResetUserStats(User user)
    {
        user.UserStats.TotalDecksCreated = 0;
        user.UserStats.TotalCardsCreated = 0;
        user.UserStats.TotalCardsLearned = 0;
        user.UserStats.StudyStreak = 0;
        user.UserStats.TotalSessionsCompleted = 0;
        user.UserStats.TotalCorrectAnswers = 0;
    }

    public async Task UpgradeToPremium(int userId)
    {
        var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == userId);

        if (user.IsPremium)
        {
            throw new AlreadyPremiumException("This user has already upgraded to the premium version");
        }

        user.IsPremium = true;

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }
}
