using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class FeedbackService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;

    public FeedbackService(ApplicationDbContext dbContext) : base(dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedResponse<Feedback>> GetAllFeedback
        (int page, int pageSize, string? status, string? accountType, string? sortBy, bool sortDescending)
    {
        var query = _dbContext.Feedbacks.AsQueryable();

        if (!string.IsNullOrEmpty(status) && Enum.TryParse<FeedbackStatus>(status, true, out var feedbackStatus))
        {
            query = query.Where(f => f.FeedbackStatus == feedbackStatus);
        }

        if (!string.IsNullOrEmpty(accountType))
        {
            if (accountType == "free")
            {
                query = query.Where(f => f.IsPremiumUser == false);
            } else if (accountType == "premium")
            {
                query = query.Where(f => f.IsPremiumUser == true);
            }
        }

        query = sortBy switch
        {
            "title" => sortDescending ? query.OrderByDescending(f => f.Title) : query.OrderBy(f => f.Title),
            "date" => sortDescending ? query.OrderByDescending(f => f.SubmittedAt) : query.OrderBy(f => f.SubmittedAt),
            "status" => sortDescending ? query.OrderByDescending(f => f.FeedbackStatus) : query.OrderBy(f => f.FeedbackStatus),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var feedbackList = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<Feedback>(feedbackList, page, totalPages);
    }

    public async Task<Feedback> UpdateFeedbackStatus(int feedbackId, FeedbackStatusUpdateRequest feedbackUpdateRequest)
    {
        var feedback = await _dbContext.Feedbacks
            .FirstAsync(f => f.Id == feedbackId);

        feedback.FeedbackStatus = feedbackUpdateRequest.Status;

        _dbContext.Feedbacks.Update(feedback);
        await _dbContext.SaveChangesAsync();
        
        return feedback;
    }
}
