using MemoWise.Model.DTO;
using MemoWise.Model.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class UsersController : BaseCRUDController<User, UserCreateRequest, UserUpdateRequest>
{
    private readonly UserService _userService;

    public UsersController(UserService userService) : base(userService) 
    {
        _userService = userService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllUsers
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, string? accountType = null, string? role = null)
    {
        var users = await _userService.GetAllUsers(page, pageSize, sortBy, sortDescending, accountType, role);
        return Ok(users);
    }

    [HttpPut]
    public async Task<IActionResult> UpdateCredentials(UpdateUserRequest updateUserRequest)
    {
        await _userService.UpdateCredentials(updateUserRequest);
        return Ok();
    }

    [HttpPut("password-change")]
    public async Task<IActionResult> ChangePassword(ChangePasswordRequest changePasswordRequest)
    {
        await _userService.ChangePassword(changePasswordRequest);
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteAccount(DeleteUserRequest deleteUserRequest)
    {
        await _userService.DeleteAccount(deleteUserRequest);
        return Ok();
    }

    [HttpGet("premium-upgrade/{userId}")]
    public async Task<IActionResult> UpgradeToPremium(int userId)
    {
        await _userService.UpgradeToPremium(userId);
        return Ok();
    }
}