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

    public async Task<List<Feedback>> GetAllFeedback()
    {
        return await _dbContext.Feedbacks.ToListAsync();
    }


    public async Task<PaginatedList<Feedback>> GetPaginatedFeedback(int page, int pageSize)
    {
        var feedbackList = await _dbContext.Feedbacks
            .OrderBy(b => b.Id)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await _dbContext.Feedbacks.CountAsync();
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
