using api.Data;
using api.DTO;
using api.Models;

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
}
