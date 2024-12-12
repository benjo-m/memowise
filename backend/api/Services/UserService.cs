using api.Data;
using api.DTO;
using api.Models;
using FirebaseAdmin.Auth;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class UserService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public UserService(ApplicationDbContext dbContext, IHttpContextAccessor httpContextAccessor)
    {
        _dbContext = dbContext;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<User> SaveUser(UserSaveRequest userRegisterRequest)
    {
        var user = new User(userRegisterRequest);
        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();
        return user;
    }

    public async Task<User?> GetCurrentUser()
    {
        string token = _httpContextAccessor.HttpContext!.Request.Headers.Authorization
            .ToString()
            .Substring("Bearer ".Length);

        FirebaseToken decodedToken = await FirebaseAuth.DefaultInstance
            .VerifyIdTokenAsync(token);

        string uid = decodedToken.Uid;

        var user = await _dbContext.Users
            .FirstOrDefaultAsync(x => x.FirebaseUid == uid);

        return user;
    }
}
