using api.DTO;

namespace api.Models;

public enum FeedbackStatus
{
    PENDING,
    SAVED,
}

public class Feedback
{
    public int Id { get; set; }
    public FeedbackStatus FeedbackStatus { get; set; } = FeedbackStatus.PENDING;
    public string Title { get; set; }
    public string Description { get; set; }
    public DateTime SubmittedAt { get; set; } = DateTime.Now;

    public Feedback()
    {
    }

    public Feedback(FeedbackCreateRequest feedbackCreateRequest)
    {
        Title = feedbackCreateRequest.Title;
        Description = feedbackCreateRequest.Description;
    }
}
