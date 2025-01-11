using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class AnalyticsController : BaseController
{
    private readonly AnalyticsService _analyticsService;

    public AnalyticsController(AnalyticsService analyticsService)
    {
        _analyticsService = analyticsService;
    }

    [Authorize(Roles = "SuperAdmin,Admin")]
    [HttpGet("dashboard-data")]
    public async Task<ActionResult<DashboardData>> GetDashboardData()
    {
        return await _analyticsService.GetDashboardData();
    }

    [Authorize(Roles = "SuperAdmin,Admin")]
    [HttpGet("analytics-data")]
    public async Task<ActionResult<AnalyticsData>> GetAnalyticsData(int year)
    {
        return await _analyticsService.GetAnalyticsData(year);
    }
}
