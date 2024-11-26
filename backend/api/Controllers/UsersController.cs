using api.DTO;
using api.Models;
using api.Services;
using FirebaseAdmin.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase
{
    private readonly UserService _firebaseService;

    public UsersController(UserService firebaseService)
    {
        _firebaseService = firebaseService;
    }

    [HttpPost("save")]
    public async Task<User> SaveUser(UserSaveRequest userRegisterRequest)
    {
        return await _firebaseService.SaveUser(userRegisterRequest);
    }
}