using api.Data;
using api.DTO;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;

namespace api.Services;

public class AnalyticsService
{
    private readonly ApplicationDbContext _dbContext;

    public AnalyticsService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<UserGrowthResponse> GetUserGrowth()
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

        // Generate a complete list of months for the last 3 months
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

    public async Task<UserDistributionResponse> GetUserDistribution()
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

    public async Task<DashboardData> GetDashboardData()
    {
        return new DashboardData()
        {
            UserGrowth = await GetUserGrowth(),
            UserDistribution = await GetUserDistribution(),
        };
    }

}
