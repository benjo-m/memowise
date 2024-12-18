using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class AchievementsService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly UserService _userService;

    public AchievementsService(ApplicationDbContext dbContext, UserService userService)
    {
        _dbContext = dbContext;
        _userService = userService;
    }

    public async Task<List<Achievement>> GetAllAchievements()
    {
        return await _dbContext.Achievements
            .ToListAsync();
    }

    public async Task<List<Achievement>?> GetUnlockedAchievements(int userId)
    {
        return await _dbContext.Users
            .Where(u => u.Id == userId)
            .Select(u => u.Achievements)
            .FirstOrDefaultAsync();
    }

    public async Task<Achievement?> UnlockAchievement(AddAchievementRequest addAchievementRequest)
    {
        var user = await _dbContext.Users
            .Include(u => u.Achievements)
            .SingleOrDefaultAsync(u => u.Id == addAchievementRequest.UserId);

        var achievement = await _dbContext.Achievements
            .SingleOrDefaultAsync(a => a.Id ==  addAchievementRequest.AchievementId);

        if (user == null || achievement == null)
        {
            return null;
        }

        user.Achievements.Add(achievement);

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();

        return achievement;
    }
    
    //public async Task CheckAchievements()
    //{
    //    var user = await _userService.GetCurrentUser();
        
    //}

}
