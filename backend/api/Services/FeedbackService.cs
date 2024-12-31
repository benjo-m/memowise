using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using System.Numerics;

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

    public async Task PostFeedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        var feedback = new Feedback(feedbackCreateRequest);

        _dbContext.Feedbacks.Add(feedback);
        await _dbContext.SaveChangesAsync();
    }
}
