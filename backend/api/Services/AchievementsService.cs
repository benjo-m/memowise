using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class AchievementsService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly UserService _userService;

    public AchievementsService(ApplicationDbContext dbContext, UserService userService)
    {
        _dbContext = dbContext;
        _userService = userService;
    }

    public async Task<List<Achievement>> GetAllAchievements()
    {
        return await _dbContext.Achievements
            .ToListAsync();
    }

    public async Task<List<Achievement>?> GetUnlockedAchievements(int userId)
    {
        return await _dbContext.Users
            .Where(u => u.Id == userId)
            .Select(u => u.Achievements)
            .FirstOrDefaultAsync();
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
        var unlockedAchievements = await GetUnlockedAchievements(userId);
        var achievements = await GetAllAchievements();
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
            else if (achievement.Name == "Deck designer" && userStats.TotalCardsCreated >= 20)
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
