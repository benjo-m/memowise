namespace api.DTO;

public class CardAddRequest
{
    public string Question { get; set; }
    public string Answer { get; set; }
    public string? QuestionImage { get; set; }
    public string? AnswerImage { get; set; }
}
