namespace api.DTO;

public class CardCreateRequest
{
    public required string Question { get; set; }
    public required string Answer { get; set; }
}