using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public enum FeedbackStatus
{
    PENDING,
    SAVED,
}

public class Feedback
{
    public int Id { get; set; }
    public int UserId { get; set; }
    [JsonIgnore]
    public User User { get; set; }
    public FeedbackStatus FeedbackStatus { get; set; } = FeedbackStatus.PENDING;
    public string Title { get; set; }
    public string Description { get; set; }

    public Feedback()
    {
    }

    public Feedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        UserId = feedbackCreateRequest.UserId;
        Title = feedbackCreateRequest.Title;
        Description = feedbackCreateRequest.Description;
    }
}
