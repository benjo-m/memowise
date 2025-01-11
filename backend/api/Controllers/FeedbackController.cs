using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class FeedbackController : BaseCRUDController<Feedback, FeedbackCreateRequest, FeedbackUpdateRequest>
{
    private readonly FeedbackService _feedbackService;

    public FeedbackController(FeedbackService feedbackService) : base(feedbackService)
    {
        _feedbackService = feedbackService;
    }

    [Authorize(Roles = "Admin,SuperAdmin")]
    [HttpGet]
    public async Task<PaginatedResponse<Feedback>> GetAllFeedback
        (int page = 1, int pageSize = 10, string? status = null, string? accountType = null, string? sortBy = "id", bool sortDescending = false)
    {
        return await _feedbackService.GetAllFeedback(page, pageSize, status, accountType, sortBy, sortDescending);
    }

    [Authorize(Roles = "Admin,SuperAdmin")]
    [HttpPut("{id}/status")]
    public async Task<Feedback> UpdateFeedbackStatus(int id, FeedbackStatusUpdateRequest feedbackUpdateRequest)
    {
        return await _feedbackService.UpdateFeedbackStatus(id, feedbackUpdateRequest);
    }
}
