namespace MemoWise.Model.DTO;

public class CardUpdateRequest
{
    public string Question { get; set; }
    public string Answer { get; set; }
    public int DeckId { get; set; }
}
