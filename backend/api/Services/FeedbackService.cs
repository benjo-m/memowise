using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class FeedbackService
{
    private readonly ApplicationDbContext _dbContext;

    public FeedbackService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedList<Feedback>> GetPaginatedFeedback
        (int page, int pageSize, string? filterByStatus, string? sortBy, bool sortDescending)
    {
        var query = _dbContext.Feedbacks.AsQueryable();

        if (!string.IsNullOrEmpty(filterByStatus) && Enum.TryParse<FeedbackStatus>(filterByStatus, true, out var status))
        {
            query = query.Where(f => f.FeedbackStatus == status);
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

        return new PaginatedList<Feedback>(feedbackList, page, totalPages);
    }

    public async Task<Feedback> GetFeedbackById(int id)
    {
        var feedback = await _dbContext.Feedbacks
            .FirstAsync(f => f.Id == id);

        return feedback;
    }

    public async Task PostFeedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        var feedback = new Feedback(feedbackCreateRequest);

        _dbContext.Feedbacks.Add(feedback);
        await _dbContext.SaveChangesAsync();
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

    public async Task<Feedback> RemoveFeedback(int feedbackId)
    {
        var feedback = await _dbContext.Feedbacks
            .FirstAsync(f => f.Id == feedbackId);

        _dbContext.Feedbacks.Remove(feedback);
        await _dbContext.SaveChangesAsync();

        return feedback;
    }
}
