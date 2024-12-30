using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[AllowAnonymous]
public class AnalyticsController : BaseController
{
    private readonly AnalyticsService _analyticsService;

    public AnalyticsController(AnalyticsService analyticsService)
    {
        _analyticsService = analyticsService;
    }

    [HttpGet("user-growth")]
    public async Task<ActionResult<UserGrowthResponse>> GetUserGrowth()
    {
       return await _analyticsService.GetUserGrowth();
    }

    [HttpGet("user-distribution")]
    public async Task<ActionResult<UserDistributionResponse>> GetUserDistribution()
    {
        return await _analyticsService.GetUserDistribution();
    }

    [HttpGet("dashboard-data")]
    public async Task<ActionResult<DashboardData>> GetDashboardData()
    {
        return await _analyticsService.GetDashboardData();
    }
}
