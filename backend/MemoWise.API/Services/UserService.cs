using api.Data;
using MemoWise.Model.DTO;
using api.Exceptions;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace api.Services;

public class UserService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly AuthService _authService;

    public UserService(ApplicationDbContext dbContext, AuthService authService) : base(dbContext)
    {
        _dbContext = dbContext;
        _authService = authService;
    }

    public async Task<PaginatedResponse<UserResponse>> GetAllUsers
        (int page, int pageSize, string? sortBy, bool sortDescending, string? accountType, string? role)
    {
        var query = _dbContext.Users
            .Select(user => new UserResponse
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                IsPremium = user.IsPremium,
                IsAdmin = user.IsAdmin,
                CreatedAt = user.CreatedAt
            });

        if (!accountType.IsNullOrEmpty())
        {
            if (accountType == "premium")
            {
                query = query.Where(u => u.IsPremium);
            }
            else if (accountType == "free")
            {
                query = query.Where(u => !u.IsPremium);
            }
        }

        if (!role.IsNullOrEmpty())
        {
            if (role == "user")
            {
                query = query.Where(u => !u.IsAdmin);
            }
            else if (role == "admin")
            {
                query = query.Where(u => u.IsAdmin);
            }
        }

        query = sortBy switch
        {
            "username" => sortDescending ? query.OrderByDescending(d => d.Username) : query.OrderBy(d => d.Username),
            "email" => sortDescending ? query.OrderByDescending(d => d.Email) : query.OrderBy(d => d.Email),
            "accountType" => sortDescending ? query.OrderByDescending(d => d.IsPremium) : query.OrderBy(d => d.IsPremium),
            "role" => sortDescending ? query.OrderByDescending(d => d.IsAdmin) : query.OrderBy(d => d.IsAdmin),
            "date" => sortDescending ? query.OrderByDescending(d => d.CreatedAt) : query.OrderBy(d => d.CreatedAt),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var users = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<UserResponse>(users, page, totalPages);
    }

    public async Task UpdateCredentials(UpdateUserRequest updateUserRequest)
    {
        var user = await _authService.GetCurrentUser();

        if (user == null)
        {
            return;
        }

        bool isUsernameTaken = await _dbContext.Users.AnyAsync(u => u.Username == updateUserRequest.Username);
        bool isEmailTaken = await _dbContext.Users.AnyAsync(u => u.Email == updateUserRequest.Email);

        if (isUsernameTaken && user.Username != updateUserRequest.Username)
        {
            throw new DuplicateEntryException("USERNAME_TAKEN", "Username taken");
        }

        if (isEmailTaken && user.Email != updateUserRequest.Email)
        {
            throw new DuplicateEntryException("EMAIL_TAKEN", "Email already in use");
        }
        
        user.Username = updateUserRequest.Username;
        user.Email = updateUserRequest.Email;
        
        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task ChangePassword(ChangePasswordRequest changePasswordRequest)
    {
        var user = await _authService.GetCurrentUser();

        if (user == null || !BCrypt.Net.BCrypt.Verify(changePasswordRequest.CurrentPassword, user.PasswordHashed))
        {
            throw new WrongPasswordException("Wrong Password");
        }

        if (changePasswordRequest.CurrentPassword == changePasswordRequest.NewPassword)
        {
            return;
        }

        user.PasswordHashed = BCrypt.Net.BCrypt.HashPassword(changePasswordRequest.NewPassword);

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAccount(DeleteUserRequest deleteUserRequest)
    {
        var user = await _authService.GetCurrentUser();

        if (user == null || !BCrypt.Net.BCrypt.Verify(deleteUserRequest.Password, user.PasswordHashed))
        {
            throw new WrongPasswordException("Wrong Password");
        }

        _dbContext.Users.Remove(user);
        await _dbContext.SaveChangesAsync();
    }

    public async Task UpgradeToPremium(int userId)
    {
        var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == userId);

        if (user.IsPremium)
        {
            throw new AlreadyPremiumException("This user has already upgraded to the premium version");
        }

        user.IsPremium = true;

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }
}
