using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

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
}
