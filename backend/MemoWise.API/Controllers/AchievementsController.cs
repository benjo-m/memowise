﻿using MemoWise.Model.DTO;
using MemoWise.Model.Models;
using api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace api.Controllers;

public class AchievementsController : BaseCRUDController<Achievement, AchievementCreateRequest, AchievementUpdateRequest>
{
    private readonly AchievementsService _achievementsService;

    public AchievementsController(AchievementsService achievementsService) : base(achievementsService)
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
