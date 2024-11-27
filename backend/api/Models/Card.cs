using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public enum CardStatus
{
    New,
    Learning,
    Learned
}

public class Card
{
    public int Id { get; set; }
    public string Question { get; set; }
    public string Answer { get; set; }
    public CardStatus Status { get; set; }
    public int DeckId { get; set; }
    [JsonIgnore]
    public Deck Deck { get; set; }

    public Card() {}
    
    public Card(CardCreateRequest cardCreateRequest)
    {
        Question = cardCreateRequest.Question;
        Answer = cardCreateRequest.Answer;
    }
}
