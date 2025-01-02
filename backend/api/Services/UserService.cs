using api.Data;
using api.DTO;
using api.Exceptions;
using api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace api.Services;

public class UserService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly AuthService _authService;

    public UserService(ApplicationDbContext dbContext, AuthService authService)
    {
        _dbContext = dbContext;
        _authService = authService;
    }

    public async Task UpdateUser(UpdateUserRequest updateUserRequest)
    {
        var user = await _authService.GetCurrentUser();

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
        var user = await _authService.GetCurrentUser();

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
        var user = await _authService.GetCurrentUser();

        if (user == null || !BCrypt.Net.BCrypt.Verify(deleteUserRequest.Password, user.PasswordHashed))
        {
            throw new WrongPasswordException("Wrong Password");
        }

        _dbContext.Users.Remove(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAllData()
    {
        var user = await _authService.GetCurrentUser();

        if (user == null)
        {
            return;
        }

        ResetUserStats(user);

        var decks = await _dbContext.Decks
            .Where(d => d.UserId == user.Id)
            .ToListAsync();

        var studySessions = await _dbContext.StudySessions
            .Where(d => d.UserId == user.Id)
            .ToListAsync();

        await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM AchievementUser WHERE UsersId = {0}", user.Id);

        _dbContext.Decks.RemoveRange(decks);
        _dbContext.StudySessions.RemoveRange(studySessions);
        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    private void ResetUserStats(User user)
    {
        user.UserStats.TotalDecksCreated = 0;
        user.UserStats.TotalDecksGenerated = 0;
        user.UserStats.TotalCardsCreated = 0;
        user.UserStats.TotalCardsLearned = 0;
        user.UserStats.StudyStreak = 0;
        user.UserStats.LongestStudyStreak = 0;
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

    public async Task<StatsResponse> GetStats(int userId)
    {
        var userStats = await _dbContext.UserStats
            .FirstOrDefaultAsync(us => us.UserId == userId);

        var userDecks = await _dbContext.Decks
            .Include(d => d.Cards)
            .Where(deck => deck.UserId == userId)
            .ToListAsync();

        var averageDeckSize = Math.Round(userDecks
            .Select(deck => deck.Cards.Count)
            .DefaultIfEmpty(0)
            .Average(), 1);

        var userStudySessions = await _dbContext.StudySessions
            .Include(ss => ss.Deck)
            .Where(ss => ss.UserId == userId)
            .ToListAsync();

        var totalCardsRated1 = userStudySessions.Sum(ss => ss.CardsRated1);
        var totalCardsRated2 = userStudySessions.Sum(ss => ss.CardsRated2);
        var totalCardsRated3 = userStudySessions.Sum(ss => ss.CardsRated3);
        var totalCardsRated4 = userStudySessions.Sum(ss => ss.CardsRated4);
        var totalCardsRated5 = userStudySessions.Sum(ss => ss.CardsRated5);

        var mostStudiedDecks = userStudySessions
            .GroupBy(ss => ss.Deck)
            .Select(group => new MostStudiedDeck
            {
                DeckName = group.Key.Name,
                TimesStudied = group.Count()
            })
            .OrderByDescending(x => x.TimesStudied)
            .Take(5)
            .ToList();

        var timeSpentStudying = userStudySessions.Sum(ss => ss.Duration);

        var longestStudySession = userStudySessions
            .OrderByDescending(ss => ss.Duration)
            .FirstOrDefault()?.Duration ?? 0;

        var durations = userStudySessions
            .Select(ss => ss.Duration)
            .ToList();


        var averageStudySessionDuration = durations.IsNullOrEmpty() ? 0 : Math.Round(durations.Average(), 2);

        return new StatsResponse()
        {
            TotalDecksCreated = userStats!.TotalDecksCreated,
            TotalDecksCreatedManually = userStats.TotalDecksCreated - userStats.TotalDecksGenerated,
            TotalDecksGenerated = userStats.TotalDecksGenerated,
            MostStudiedDecks = mostStudiedDecks,
            AverageDeckSize = averageDeckSize,
            TotalCardsCreated = userStats.TotalCardsCreated,
            TotalCardsLearned = userStats.TotalCardsLearned,
            TotalCardsRated1 = totalCardsRated1,
            TotalCardsRated2 = totalCardsRated2,
            TotalCardsRated3 = totalCardsRated3,
            TotalCardsRated4 = totalCardsRated4,
            TotalCardsRated5 = totalCardsRated5,
            TimeSpentStudying = timeSpentStudying,
            CurrentStudyStreak = userStats.StudyStreak,
            LongestStudyStreak = userStats.LongestStudyStreak,
            LongestStudySession = longestStudySession,
            AverageStudySessionDuration = averageStudySessionDuration
        };
    }

    public async Task<List<int>> GetUserIds()
    {
        return await _dbContext.Users.Select(u => u.Id).ToListAsync();
    }
}
