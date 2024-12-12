using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase
{
    private readonly UserService _userService;

    public UsersController(UserService userService)
    {
        _userService = userService;
    }

    [HttpPost("save")]
    public async Task<User> SaveUser(UserSaveRequest userRegisterRequest)
    {
        return await _userService.SaveUser(userRegisterRequest);
    }
}