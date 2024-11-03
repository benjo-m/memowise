using api.DTO;

namespace api.Models;

public class Card
{
    public int Id { get; set; }
    public string Question { get; set; }
    public string Answer { get; set; }
    public int DeckId { get; set; }
    public Deck Deck { get; set; }

    public Card() {}
    
    public Card(CardCreateRequest cardCreateRequest)
    {
        Question = cardCreateRequest.Question;
        Answer = cardCreateRequest.Answer;
    }
}
