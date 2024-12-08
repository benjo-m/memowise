using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public class Card
{
    public int Id { get; set; }
    public string Question { get; set; }
    public string Answer { get; set; }
    public int Repetitions { get; set; } = 0;
    public int Interval { get; set; } = 0;
    public float EaseFactor { get; set; } = 2.5f;
    public DateTime DueDate { get; set; } = DateTime.Now;
    public int DeckId { get; set; }
    [JsonIgnore]
    public Deck Deck { get; set; }

    public Card() {}
    
    public Card(CardDto cardDto)
    {
        Question = cardDto.Question;
        Answer = cardDto.Answer;
    }

    public void UpdateLearningStats(CardStatsUpdateRequest request)
    {
        Repetitions = request.Repetitions;
        Interval = request.Interval;
        EaseFactor = request.EaseFactor;
        DueDate = DueDate.AddDays(request.Interval);
    }
}
