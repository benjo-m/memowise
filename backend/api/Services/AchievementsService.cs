using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class AchievementsService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;

    public AchievementsService(ApplicationDbContext dbContext) : base(dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedResponse<Achievement>> GetAllAchievements
        (int page, int pageSize, string? sortBy, bool sortDescending)
    {
        var query = _dbContext.Achievements.AsQueryable();

        query = sortBy switch
        {
            "name" => sortDescending ? query.OrderByDescending(a => a.Name) : query.OrderBy(a => a.Name),
            "description" => sortDescending ? query.OrderByDescending(a => a.Description) : query.OrderBy(a => a.Description),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var achievements = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<Achievement>(achievements, page, totalPages);
    }

    public async Task<UnlockedAchievementsResponse> GetUnlockedAchievements(int userId)
    {
        var unlockedAchievements = await _dbContext.Users
            .Where(u => u.Id == userId)
            .Select(u => u.Achievements)
            .FirstAsync();

        int totalAchievementCount = await _dbContext.Achievements.CountAsync();

        return new UnlockedAchievementsResponse()
        {
            Achievements = unlockedAchievements,
            Progress = Math.Round(((double)unlockedAchievements.Count / totalAchievementCount) * 100, 1)
        };
    }

    public async Task<Achievement?> UnlockAchievement(int achievementId, int userId)
    {
        var user = await _dbContext.Users
            .Include(u => u.Achievements)
            .SingleOrDefaultAsync(u => u.Id == userId);

        var achievement = await _dbContext.Achievements
            .SingleOrDefaultAsync(a => a.Id ==  achievementId);

        if (user == null || achievement == null)
        {
            return null;
        }

        user.Achievements.Add(achievement);

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();

        return achievement;
    }

    public async Task CheckAchievements(int userId)
    {
        var unlockedAchievementsResponse = await GetUnlockedAchievements(userId);
        var unlockedAchievements = unlockedAchievementsResponse.Achievements;
        var achievementsPaginated = await GetAllAchievements(1, 20, "id", false);
        var achievements = achievementsPaginated.Data;
        var userStats = await _dbContext.UserStats
            .SingleAsync(us => us.UserId == userId);
        var lastSession = await _dbContext.StudySessions
            .Where(ss => ss.UserId == userId)
            .OrderByDescending(ss => ss.StudiedAt)
            .FirstOrDefaultAsync();
        var lastTwoSessions = _dbContext.StudySessions
            .Where(ss => ss.UserId == userId)
            .OrderByDescending(ss => ss.StudiedAt)
            .Take(2)
            .ToList();
        var todaySessions = await _dbContext.StudySessions
            .Where(ss => ss.UserId == userId)
            .Where(ss => ss.StudiedAt.Date == DateTime.Today)
            .ToListAsync();

        foreach (var achievement in achievements)
        {
            if (unlockedAchievements!.Any(ua => ua.Name == achievement.Name))
                continue;

            if (achievement.Name == "Consistent Learner" && userStats.StudyStreak >= 30)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "First Steps" && userStats.TotalSessionsCompleted >= 1)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Committed Student" && userStats.TotalSessionsCompleted >= 10)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Perfect Recall" && lastSession?.AverageRepetitions == 1)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Daily Devotion" && (todaySessions.Sum(ss => ss.Duration) / 60) >= 60)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Early Bird" && (lastSession?.StudiedAt.TimeOfDay >= new TimeSpan(4, 0, 0) && lastSession.StudiedAt.TimeOfDay <= new TimeSpan(7, 0, 0)))
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Night Owl" && (lastSession?.StudiedAt.TimeOfDay >= new TimeSpan(22, 0, 0)))
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Speed Demon" && lastSession?.CardCount >= 50 && (lastSession.Duration / 60) <= 5)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Flashcard Pro" && userStats.TotalCardsLearned >= 100)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Deck Designer" && userStats.TotalCardsCreated >= 20)
            {
                await UnlockAchievement(achievement.Id, userId);
            }
            else if (achievement.Name == "Weekend Warrior")
            {
                if (lastTwoSessions.Count == 2 && lastTwoSessions[0].StudiedAt.DayOfWeek == DayOfWeek.Sunday && lastTwoSessions[1].StudiedAt.DayOfWeek == DayOfWeek.Saturday)
                {
                    await UnlockAchievement(achievement.Id, userId);
                }
            }
        }
    }

}
