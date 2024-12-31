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

    public async Task PostFeedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        var feedback = new Feedback(feedbackCreateRequest);

        _dbContext.Feedbacks.Add(feedback);
        await _dbContext.SaveChangesAsync();
    }
}
