using System.Text.Json.Serialization;
namespace MemoWise.Model.Models;
using MemoWise.Model.DTO;

public enum FeedbackStatus
{
    PENDING,
    SAVED,
    COMPLETED,
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
    public bool IsPremiumUser { get; set; }
    public DateTime SubmittedAt { get; set; } = DateTime.Now;

    public Feedback()
    {
    }

    public Feedback(FeedbackCreateRequest request)
    {
        Title = request.Title;
        Description = request.Description;
        SubmittedAt = request.SubmittedAt;
        FeedbackStatus = request.Status;
        UserId = request.UserId;
        IsPremiumUser = request.IsPremiumUser;
    }

    public Feedback Update(FeedbackUpdateRequest request)
    {
        Title = request.Title;
        Description = request.Description;
        SubmittedAt = request.SubmittedAt;
        FeedbackStatus = request.Status;
        UserId = request.UserId;
        return this;
    }
}
