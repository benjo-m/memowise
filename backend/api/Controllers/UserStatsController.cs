using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class UserStatsController : BaseCRUDController<UserStats, UserStatsCreateRequest, UserStatsUpdateRequest>
{
    private readonly UserStatsService _userStatsService;
    public UserStatsController(UserStatsService userStatsService) : base(userStatsService) 
    {
        _userStatsService = userStatsService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllUserStats
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? user = null)
    {
        var userStats = await _userStatsService.GetAllUserStats(page, pageSize, sortBy, sortDescending, user);
        return Ok(userStats);
    }

    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetStatsByUser(int userId)
    {
        var userStats = await _userStatsService.GetStatsByUser(userId);
        return Ok(userStats);
    }

    [HttpPut("delete-data/{userId}")]
    public async Task<IActionResult> DeleteAllData(int userId)
    {
        await _userStatsService.DeleteAllData(userId);
        return Ok();
    }
}
