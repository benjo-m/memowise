using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace api.Services;

public class UserStatsService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;

    public UserStatsService(ApplicationDbContext dbContext) : base(dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedResponse<UserStatsDto>> GetAllUserStats
        (int page, int pageSize, string? sortBy, bool sortDescending, int? user)
    {
        var query = _dbContext.UserStats
            .Select(stats => new UserStatsDto
            {
                Id = stats.Id,
                UserId = stats.UserId,
                TotalDecksCreated = stats.TotalDecksCreated,
                TotalDecksGenerated = stats.TotalDecksGenerated,
                TotalCardsCreated = stats.TotalCardsCreated,
                TotalCardsLearned = stats.TotalCardsLearned,
                StudyStreak = stats.StudyStreak,
                LongestStudyStreak = stats.LongestStudyStreak,
                TotalSessionsCompleted = stats.TotalSessionsCompleted,
                TotalCorrectAnswers = stats.TotalCorrectAnswers
            });

        if (user != null)
        {
            query = query.Where(d => d.UserId == user);
        }

        query = sortBy switch
        {
            "user" => sortDescending ? query.OrderByDescending(d => d.UserId) : query.OrderBy(d => d.UserId),
            "totalDecksCreated" => sortDescending ? query.OrderByDescending(d => d.TotalDecksCreated) : query.OrderBy(d => d.TotalDecksCreated),
            "totalCardsCreated" => sortDescending ? query.OrderByDescending(d => d.TotalCardsCreated) : query.OrderBy(d => d.TotalCardsCreated),
            "totalCardsLearned" => sortDescending ? query.OrderByDescending(d => d.TotalCardsLearned) : query.OrderBy(d => d.TotalCardsLearned),
            "studyStreak" => sortDescending ? query.OrderByDescending(d => d.StudyStreak) : query.OrderBy(d => d.StudyStreak),
            "totalSessionsCompleted" => sortDescending ? query.OrderByDescending(d => d.TotalSessionsCompleted) : query.OrderBy(d => d.TotalSessionsCompleted),
            "totalCorrectAnswers" => sortDescending ? query.OrderByDescending(d => d.TotalCorrectAnswers) : query.OrderBy(d => d.TotalCorrectAnswers),
            "totalDecksGenerated" => sortDescending ? query.OrderByDescending(d => d.TotalDecksGenerated) : query.OrderBy(d => d.TotalDecksGenerated),
            "longestStudyStreak" => sortDescending ? query.OrderByDescending(d => d.LongestStudyStreak) : query.OrderBy(d => d.LongestStudyStreak),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var userStats = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<UserStatsDto>(userStats, page, totalPages);
    }

    public async Task<StatsResponse> GetStatsByUser(int userId)
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

    public async Task DeleteAllData(int userId)
    {
        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .FirstOrDefaultAsync(u => u.Id == userId);

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
}
