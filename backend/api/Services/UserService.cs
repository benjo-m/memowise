using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

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
        var userId = _httpContextAccessor.HttpContext!.User
            .FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (userId == null)
        {
            return null;
        }

        var user = await _dbContext.Users
            .FirstOrDefaultAsync(u => u.Id == int.Parse(userId));

        return user;
    }

    public async Task<User?> Login(string username, string password)
    {
        var user = await _dbContext.Users
            .Where(u => u.Username == username && u.Password == password)
            .FirstOrDefaultAsync();

        return user;
    }
}
