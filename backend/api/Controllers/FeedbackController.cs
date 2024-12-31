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
    public async Task<List<Feedback>> GetAllFeedback()
    {
        return await _feedbackService.GetAllFeedback();
    }

    [HttpPost]
    public async Task PostFeedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        await _feedbackService.PostFeedback(feedbackCreateRequest);
    }
}
