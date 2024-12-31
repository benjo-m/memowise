using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[AllowAnonymous]
public class FeedbackController : BaseController
{
    private readonly FeedbackService _feedbackService;

    public FeedbackController(FeedbackService feedbackService)
    {
        _feedbackService = feedbackService;
    }

    [HttpGet]
    public async Task<PaginatedList<Feedback>> GetAllFeedback(int page = 1, int pageSize = 10)
    {
        return await _feedbackService.GetPaginatedFeedback(page, pageSize);
    }

    [HttpPost]
    public async Task PostFeedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        await _feedbackService.PostFeedback(feedbackCreateRequest);
    }
}
