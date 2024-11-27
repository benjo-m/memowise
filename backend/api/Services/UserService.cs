using api.Data;
using api.DTO;
using api.Models;
using FirebaseAdmin.Auth;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class UserService
{
    private readonly ApplicationDbContext _dbContext;

    public UserService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<User> SaveUser(UserSaveRequest userRegisterRequest)
    {
        var user = new User(userRegisterRequest);
        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();
        return user;
    }

    public async Task<User?> GetCurrentUser(string? token)
    {
        FirebaseToken decodedToken = await FirebaseAuth.DefaultInstance
            .VerifyIdTokenAsync(token);

        string uid = decodedToken.Uid;

        return await _dbContext.Users.FirstOrDefaultAsync(x => x.FirebaseUid == uid);
    }
}
