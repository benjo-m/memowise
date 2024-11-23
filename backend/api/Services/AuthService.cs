using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class AuthService
{
    private readonly ApplicationDbContext _dbContext;

    public AuthService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<User> Register(UserCreateRequest userCreateRequest) {
        User user = new User(userCreateRequest);
        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();
        return user;
    }

    public async Task<UserDto?> LogIn(LoginRequest loginRequest) {
        var user = await _dbContext.Users
            .FirstOrDefaultAsync(x => x.Username == loginRequest.Username && x.Password == loginRequest.Password);

        var userDto = new UserDto();
        userDto.Username = user.Username;
        userDto.Email = user.Email;

        return userDto;
    }

    public async Task LogOut()
    {

    }
}