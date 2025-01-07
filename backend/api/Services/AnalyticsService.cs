using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

namespace api.Services;

public class AnalyticsService
{
    private readonly ApplicationDbContext _dbContext;

    public AnalyticsService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<DashboardData> GetDashboardData()
    {
        return new DashboardData()
        {
            UserGrowth = await GetUserGrowth(),
            UserDistribution = await GetUserDistribution(),
            NewUsers = await GetNewUsers(),
            ActiveUsers = await GetActiveUsers(),
            FeedbackCount = await GetFeedbackCount()
        };
    }

    public async Task<AnalyticsData> GetAnalyticsData(int year)
    {
        double averageEaseFactor = await _dbContext.CardStats.AverageAsync(cs => cs.EaseFactor);
        int totalDecksCreated = await _dbContext.UserStats.SumAsync(us => us.TotalDecksCreated);
        int generatedDecksCount = await _dbContext.UserStats.SumAsync(us => us.TotalDecksGenerated);
        int manuallyCreatedDecksCount = totalDecksCreated - generatedDecksCount;
        double averageSessionDuration = await _dbContext.StudySessions.AverageAsync(ss => ss.Duration);
        double averageStudyStreak = await _dbContext.UserStats.AverageAsync(us => us.StudyStreak);
        var cardCount = await _dbContext.Cards.CountAsync();
        var deckCount = await _dbContext.Decks.CountAsync();

        return new AnalyticsData
        {
            TotalUsers = await _dbContext.Users.CountAsync(),
            TotalPremiumUsers = await _dbContext.Users.Where(u => u.IsPremium == true).CountAsync(),
            DailyActiveUsers = await GetActiveUsersByTimePeriod(1),
            MonthlyActiveUsers = await GetActiveUsersByTimePeriod(30),
            NewUsersByMonth = await GetNewUsersByMonth(year),
            UserDistribution = await GetUserDistribution(),
            UserGrowth = await GetUserGrowth(),
            TotalDecksCreated = await _dbContext.UserStats.SumAsync(us => us.TotalDecksCreated),
            TotalCardsCreated = await _dbContext.UserStats.SumAsync(us => us.TotalCardsCreated),
            AverageDeckSize = deckCount == 0 ? 0 : Math.Round((double)cardCount / (double)deckCount, 2),
            AverageEaseFactor = Math.Round(averageEaseFactor, 2),
            ManuallyCreatedDecksPercentage = Math.Round((double)manuallyCreatedDecksCount / totalDecksCreated * 100, 1),
            GeneratedDecksPercentage = Math.Round((double)generatedDecksCount / totalDecksCreated * 100, 1),
            TotalStudySessions = await _dbContext.StudySessions.CountAsync(),
            TotalTimeSpentStudying = await _dbContext.StudySessions.SumAsync(ss => ss.Duration),
            AverageSessionDuration = Math.Round(averageSessionDuration, 2),
            AverageStudyStreak = Math.Round(averageStudyStreak, 2),
            LongestStudyStreak = await _dbContext.UserStats.MaxAsync(us => us.LongestStudyStreak),
            StudySessionSegments = await GetStudySessionSegments(),
            AchievementUnlockPercentages = await GetAchievementsUnlockPercentages()
        };
    }

    private async Task<UserDistributionResponse> GetUserDistribution()
    {
        var totalUsers = await _dbContext.Users.CountAsync();

        if (totalUsers == 0)
        {
            return new UserDistributionResponse
            {
                FreeUsersPercentage = 0,
                PremiumUsersPercentage = 0
            };
        }

        var premiumUsersCount = await _dbContext.Users.CountAsync(u => u.IsPremium);
        var freeUsersCount = totalUsers - premiumUsersCount;

        return new UserDistributionResponse
        {
            FreeUsersPercentage = Math.Round((double)freeUsersCount / totalUsers * 100, 1),
            PremiumUsersPercentage = Math.Round((double)premiumUsersCount / totalUsers * 100, 1)
        };
    }

    private async Task<UserGrowthResponse> GetUserGrowth()
    {
        var threeMonthsAgo = DateTime.Now.AddMonths(-4);
        var monthlyUserCounts = await _dbContext.Users
            .Where(u => u.CreatedAt >= threeMonthsAgo)
            .GroupBy(u => new { u.CreatedAt.Year, u.CreatedAt.Month })
            .Select(g => new
            {
                Year = g.Key.Year,
                Month = g.Key.Month,
                Count = g.Count()
            })
            .ToListAsync();

        var results = Enumerable.Range(0, 4)
            .Select(offset =>
            {
                var date = DateTime.Now.AddMonths(-offset);
                return new UserGrowthDataPoint
                {
                    Year = date.Year,
                    Month = date.Month,
                    Count = monthlyUserCounts
                        .FirstOrDefault(x => x.Year == date.Year && x.Month == date.Month)?.Count ?? 0
                };
            })
            .OrderBy(x => x.Year)
            .ThenBy(x => x.Month)
            .ToList();

        return new UserGrowthResponse()
        {
            Data = results
        };
    }

    private async Task<NewUsers> GetNewUsers()
    {
        var now = DateTime.UtcNow;
        var thirtyDaysAgo = now.AddDays(-30);
        var sixtyDaysAgo = now.AddDays(-60);

        var userCountLast30Days = await _dbContext.Users
            .CountAsync(u => u.CreatedAt >= thirtyDaysAgo && u.CreatedAt < now);

        var userCountPrevious30Days = await _dbContext.Users
            .CountAsync(u => u.CreatedAt >= sixtyDaysAgo && u.CreatedAt < thirtyDaysAgo);

        double userCountChange;
        if (userCountPrevious30Days == 0)
        {
            userCountChange = userCountLast30Days > 0 ? 100 : 0;
        }
        else
        {
            userCountChange = ((double)(userCountLast30Days - userCountPrevious30Days) / userCountPrevious30Days) * 100;
        }

        var premiumUserCountLast30Days = await _dbContext.Users
            .Where(u => u.IsPremium == true)
            .CountAsync(u => u.CreatedAt >= thirtyDaysAgo && u.CreatedAt < now);

        var pemiumUserCountPrevious30Days = await _dbContext.Users
            .Where(u => u.IsPremium == true)
            .CountAsync(u => u.CreatedAt >= sixtyDaysAgo && u.CreatedAt < thirtyDaysAgo);

        double premiumUserCountChange;
        if (pemiumUserCountPrevious30Days == 0)
        {
            premiumUserCountChange = premiumUserCountLast30Days > 0 ? 100 : 0;
        }
        else
        {
            premiumUserCountChange = ((double)(premiumUserCountLast30Days - pemiumUserCountPrevious30Days) / pemiumUserCountPrevious30Days) * 100;
        }

        return new NewUsers
        {
            UserCount = userCountLast30Days,
            UserCountChange = Math.Round(userCountChange, 1),
            PremiumUserCount = premiumUserCountLast30Days,
            PremiumUserCountChange = Math.Round(premiumUserCountChange, 1),
        };
    }

    private async Task<ActiveUsers> GetActiveUsers()
    {
        var now = DateTime.UtcNow;
        var thirtyDaysAgo = now.AddDays(-30);
        var sixtyDaysAgo = now.AddDays(-60);

        var activeUserCountLast30Days = await _dbContext.LoginRecords
            .Where(lr => lr.LoginDateTime >= thirtyDaysAgo && lr.LoginDateTime < now)
            .Select(lr => lr.UserId)
            .Distinct()
            .CountAsync();

        var activeUserCountPrevious30Days = await _dbContext.LoginRecords
            .Where(lr => lr.LoginDateTime >= sixtyDaysAgo && lr.LoginDateTime < thirtyDaysAgo)
            .Select(lr => lr.UserId)
            .Distinct()
            .CountAsync();

        double change;
        if (activeUserCountPrevious30Days == 0)
        {
            change = activeUserCountLast30Days > 0 ? 100 : 0;
        }
        else
        {
            change = ((double)(activeUserCountLast30Days - activeUserCountPrevious30Days) / activeUserCountPrevious30Days) * 100;
        }

        return new ActiveUsers
        {
            Count = activeUserCountLast30Days,
            Change = Math.Round(change, 1)
        };
    }

    private async Task<FeedbackCount> GetFeedbackCount()
    {
        var pendingFeedbackCount = await _dbContext.Feedbacks.Where(f => f.FeedbackStatus == FeedbackStatus.PENDING).CountAsync();
        var savedFeedbackCount = await _dbContext.Feedbacks.Where(f => f.FeedbackStatus == FeedbackStatus.SAVED).CountAsync();

        return new FeedbackCount
        {
            PendingFeedback = pendingFeedbackCount,
            SavedFeedback = savedFeedbackCount
        };
    }

    private async Task<int> GetActiveUsersByTimePeriod(int days)
    {
        var now = DateTime.UtcNow;
        var period = now.AddDays(-days);

        var activeUserCount = await _dbContext.LoginRecords
            .Where(lr => lr.LoginDateTime >= period && lr.LoginDateTime < now)
            .Select(lr => lr.UserId)
            .Distinct()
            .CountAsync();

        return activeUserCount;
    }

    private async Task<List<NewUsersByMonth>> GetNewUsersByMonth(int year)
    {
        var allMonths = Enumerable.Range(1, 12)
            .Select(month => new NewUsersByMonth
            {
                Month = new DateTime(year, month, 1).ToString("MMMM yyyy", CultureInfo.InvariantCulture),
                Count = 0
            })
            .ToList();

        var data = await _dbContext.Users
            .Where(u => u.CreatedAt.Year == year)
            .GroupBy(u => u.CreatedAt.Month)
            .Select(g => new
            {
                Month = g.Key,
                Count = g.Count()
            })
            .ToListAsync();

        foreach (var entry in data)
        {
            allMonths[entry.Month - 1].Count = entry.Count;
        }

        return allMonths;
    }

    private async Task<List<StudySessionSegment>> GetStudySessionSegments()
    {
        var totalSessions = await _dbContext.StudySessions.CountAsync();

        var segments = await _dbContext.StudySessions
            .GroupBy(ss =>
                ss.StudiedAt.Hour >= 5 && ss.StudiedAt.Hour < 12 ? "Morning" :
                ss.StudiedAt.Hour >= 12 && ss.StudiedAt.Hour < 17 ? "Afternoon" :
                ss.StudiedAt.Hour >= 17 && ss.StudiedAt.Hour < 21 ? "Evening" :
                "Night"
            )
            .Select(g => new StudySessionSegment
            {
                Segment = g.Key,
                Count = g.Count(),
                Percentage = Math.Round((double)g.Count() / totalSessions * 100, 1)
            })
            .OrderByDescending(s => s.Segment) 
            .ToListAsync();

        return segments;
    }

    private async Task<List<AchievementUnlockPercentage>> GetAchievementsUnlockPercentages()
    {
        var totalUsers = await _dbContext.Users.CountAsync();

        var achievementStats = await _dbContext.Achievements
            .Select(achievement => new AchievementUnlockPercentage
            {
                Name = achievement.Name,
                Percentage = totalUsers == 0
                    ? 0
                    : Math.Round((double)achievement.Users.Count() / totalUsers * 100,1)
            })
            .ToListAsync();

        return achievementStats;
    }
}
