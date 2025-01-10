using api.Models;

namespace api.DTO;

public class FeedbackUpdateRequest
{
    public string Title { get; set; }
    public string Description { get; set; }
    public FeedbackStatus Status { get; set; }
    public DateTime SubmittedAt { get; set; }
    public int UserId { get; set; }
}
