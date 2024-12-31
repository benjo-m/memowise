namespace api.DTO;

public class FeedbackCreateRequest
{
    public int UserId { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
}
