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
    public async Task<PaginatedResponse<Feedback>> GetAllFeedback
        (int page = 1, int pageSize = 10, string? status = null, string? sortBy = "id", bool sortDescending = false)
    {
        return await _feedbackService.GetAllFeedback(page, pageSize, status, sortBy, sortDescending);
    }

    [HttpGet("{id}")]
    public async Task<Feedback> GetFeedbackById(int id)
    {
        return await _feedbackService.GetFeedbackById(id);
    }

    [HttpPut("{id}/status")]
    public async Task<Feedback> UpdateFeedbackStatus(int id, FeedbackStatusUpdateRequest feedbackUpdateRequest)
    {
        return await _feedbackService.UpdateFeedbackStatus(id, feedbackUpdateRequest);
    }

    [HttpPost]
    public async Task PostFeedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        await _feedbackService.PostFeedback(feedbackCreateRequest);
    }

    [HttpDelete("{feedbackId}")]
    public async Task<Feedback> RemoveFeedback(int feedbackId)
    {
        return await _feedbackService.RemoveFeedback(feedbackId);
    }

}
