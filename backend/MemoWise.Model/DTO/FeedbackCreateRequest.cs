using MemoWise.Model.Models;

namespace MemoWise.Model.DTO;

public class FeedbackCreateRequest
{
    public string Title { get; set; }   
    public string Description { get; set; }
    public FeedbackStatus Status { get; set; }
    public DateTime SubmittedAt { get; set; }
    public int UserId { get; set; }
    public bool IsPremiumUser { get; set; }
}
