using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public class Card
{
    public int Id { get; set; }
    public string Question { get; set; }
    public string Answer { get; set; }
    public CardStats CardStats { get; set; } = new CardStats();
    public int DeckId { get; set; }
    [JsonIgnore]
    public Deck Deck { get; set; }

    public Card() {}
    
    public Card(CardCreateRequest cardCreateRequest)
    {
        Question = cardCreateRequest.Question;
        Answer = cardCreateRequest.Answer;
    }

    public void UpdateLearningStats(CardStatsUpdateRequest request)
    {
        CardStats.Repetitions = request.Repetitions;
        CardStats.Interval = request.Interval;
        CardStats.EaseFactor = request.EaseFactor;
        CardStats.DueDate = CardStats.DueDate.AddDays(request.Interval);
    }
}
