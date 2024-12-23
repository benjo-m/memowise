namespace api.DTO;

public class CardEditRequest
{
    public string Question { get; set; }
    public string Answer { get; set; }
    public string? QuestionImage { get; set; }
    public string? AnswerImage { get; set; }
}
