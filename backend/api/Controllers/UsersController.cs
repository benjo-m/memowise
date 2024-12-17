using api.DTO;
using api.Exceptions;
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
        catch (PasswordsNotMatching ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An unexpected error occurred.", details = ex.Message }); 
        }
    }
}