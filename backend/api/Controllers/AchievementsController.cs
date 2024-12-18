using api.DTO;
using api.Models;
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
    public async Task<IActionResult> GetAllAchievements()
    {
        var achievements = await _achievementsService.GetAllAchievements();
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

    [HttpPost]
    public async Task<ActionResult<Achievement>> UnlockAchievement(AddAchievementRequest addAchievementRequest)
    {
        var achievement = await _achievementsService.UnlockAchievement(addAchievementRequest);

        if (achievement == null)
        {
            return BadRequest();
        }

        return Ok(achievement);
    }
}
