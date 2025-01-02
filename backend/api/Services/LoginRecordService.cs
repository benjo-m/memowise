using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class LoginRecordService
{
    private readonly ApplicationDbContext _dbContext;

    public LoginRecordService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedResponse<LoginRecord>> GetAllLoginRecords
        (int page, int pageSize, string? sortBy, bool sortDescending, int? user)
    {
        var query = _dbContext.LoginRecords.AsQueryable();

        if (user != null)
        {
            query = query.Where(lr => lr.UserId == user);
        }

        query = sortBy switch
        {
            "user" => sortDescending ? query.OrderByDescending(lr => lr.UserId) : query.OrderBy(lr => lr.UserId),
            "date" => sortDescending ? query.OrderByDescending(lr => lr.LoginDateTime) : query.OrderBy(lr => lr.LoginDateTime),
            _ => sortDescending ? query.OrderByDescending(lr => lr.Id) : query.OrderBy(lr => lr.Id)
        };
        var loginRecords = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);
        return new PaginatedResponse<LoginRecord>(loginRecords, page, totalPages);
    }
}
