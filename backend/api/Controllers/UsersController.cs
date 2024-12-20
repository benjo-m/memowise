using api.DTO;
using api.Exceptions;
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
    [HttpPost("login")]
    public async Task<ActionResult<UserDto?>> Login(LoginRequest loginRequest)
    {
        var user = await _userService.Login(loginRequest);

        if (user == null)
        {
            return Unauthorized();
        }

        return Ok(user);
    }

    [AllowAnonymous]
    [HttpPost("register")]
    public async Task<ActionResult<UserDto?>> Register(RegisterRequest registerRequest)
    {
        try
        {
            var userDto = await _userService.Register(registerRequest);
            return Ok(userDto);
        }
        catch (UsernameTakenException ex)
        {
            return Conflict(new { errorCode = "USERNAME_TAKEN", message = ex.Message });
        }
        catch (EmailAlreadyInUseException ex)
        {
            return Conflict(new { errorCode = "EMAIL_TAKEN", message = ex.Message });
        }
        catch (PasswordsNotMatchingException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An unexpected error occurred.", details = ex.Message }); 
        }
    }

    [HttpPut]
    public async Task<IActionResult> UpdateUser(UpdateUserRequest updateUserRequest)
    {
        try
        {
            await _userService.UpdateUser(updateUserRequest);
            return Ok();
        }
        catch (UsernameTakenException ex)
        {
            return Conflict(new { errorCode = "USERNAME_TAKEN", message = ex.Message });
        }
        catch (EmailAlreadyInUseException ex)
        {
            return Conflict(new { errorCode = "EMAIL_TAKEN", message = ex.Message });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An unexpected error occurred.", details = ex.Message });
        }
    }

    [HttpPut("password")]
    public async Task<IActionResult> ChangePassword(ChangePasswordRequest changePasswordRequest)
    {
        try
        {
            await _userService.ChangePassword(changePasswordRequest);
            return Ok();
        }
        catch (WrongPasswordException)
        {
            return Unauthorized();
        }
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteUser(DeleteUserRequest deleteUserRequest)
    {
        try
        {
            await _userService.DeleteUser(deleteUserRequest);
            return Ok();
        }
        catch (WrongPasswordException)
        {
            return Unauthorized();
        }
    }
}