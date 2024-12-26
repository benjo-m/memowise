using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class AuthController : BaseController
{
    private readonly AuthService _authService;
    private readonly SeedDataService _seedDataService;

    public AuthController(AuthService authService, SeedDataService seedDataService)
    {
        _authService = authService;
        _seedDataService = seedDataService;
    }

    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<ActionResult<UserDto?>> Login(LoginRequest loginRequest)
    {
        var user = await _authService.Login(loginRequest);

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
        var userDto = await _authService.Register(registerRequest);
        return Ok(userDto);
    }

    [AllowAnonymous]
    [HttpGet]
    public void PopulateDatabase()
    {
        _seedDataService.PopulateDatabase();
    }
}
