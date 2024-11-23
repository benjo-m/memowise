using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController : ControllerBase
{
    private readonly AuthService _authService;

    public AuthController(AuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("register")]
    public async Task<ActionResult<User>> Register(UserCreateRequest userCreateRequest)
    {
        User user = await _authService.Register(userCreateRequest);
        return user;
    }

    [HttpPost("login")]
    public async Task<ActionResult<UserDto?>> Login(LoginRequest loginRequest) 
    {
        var user = await _authService.LogIn(loginRequest);

        if (user == null) return Unauthorized();

        return user;
    }
}