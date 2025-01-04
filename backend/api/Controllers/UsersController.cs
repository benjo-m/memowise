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

    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> GetAllUsers
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, string? accountType = null, string? role = null)
    {
        var users = await _userService.GetAllUsers(page, pageSize, sortBy, sortDescending, accountType, role);
        return Ok(users);
    }

    [HttpPut]
    public async Task<IActionResult> UpdateUser(UpdateUserRequest updateUserRequest)
    {
        await _userService.UpdateUser(updateUserRequest);
        return Ok();
    }

    [HttpPut("password-change")]
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

    [HttpGet("premium-upgrade/{userId}")]
    public async Task<IActionResult> UpgradeToPremium(int userId)
    {
        await _userService.UpgradeToPremium(userId);
        return Ok();
    }
}