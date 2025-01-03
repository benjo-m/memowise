using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class UsersController : BaseController
{
    private readonly UserService _userService;

    public UsersController(UserService userService)
    {
        _userService = userService;
    }

    [HttpPut]
    public async Task<IActionResult> UpdateUser(UpdateUserRequest updateUserRequest)
    {
        await _userService.UpdateUser(updateUserRequest);
        return Ok();
    }

    [HttpPut("password")]
    public async Task<IActionResult> ChangePassword(ChangePasswordRequest changePasswordRequest)
    {
        await _userService.ChangePassword(changePasswordRequest);
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteUser(DeleteUserRequest deleteUserRequest)
    {
        await _userService.DeleteUser(deleteUserRequest);
        return Ok();
    }

    [HttpPut("delete-data")]
    public async Task<IActionResult> DeleteAllData()
    {
        await _userService.DeleteAllData();
        return Ok();
    }

    [HttpGet("premium-upgrade/{userId}")]
    public async Task<IActionResult> UpgradeToPremium(int userId)
    {
        await _userService.UpgradeToPremium(userId);
        return Ok();
    }

    [HttpGet("stats/{userId}")]
    public async Task<ActionResult<StatsResponse>> GetStats(int userId)
    {
        return await _userService.GetStats(userId);
    }

    [AllowAnonymous]
    [HttpGet("ids")]
    public async Task<ActionResult<List<int>>> GetUserIds()
    {
        return await _userService.GetUserIds();
    }
}