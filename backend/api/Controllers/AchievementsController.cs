using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;


[AllowAnonymous]
public class AchievementsController : BaseController
{
    private readonly AchievementsService _achievementsService;

    public AchievementsController(AchievementsService achievementsService)
    {
        _achievementsService = achievementsService;
    }

    
    [HttpGet]
    public async Task<IActionResult> GetAllAchievements
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false)
    {
        var achievements = await _achievementsService.GetAllAchievements(page, pageSize, sortBy, sortDescending);
        return Ok(achievements);
    }

    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetUnlockedAchievements(int userId)
    {
        var achievements = await _achievementsService.GetUnlockedAchievements(userId);
        if (achievements == null)
        {
            return BadRequest();
        }

        return Ok(achievements);
    }
}
