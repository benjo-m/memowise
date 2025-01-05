using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public class Card
{
    public int Id { get; set; }
    public string Question { get; set; }
    public string Answer { get; set; }
    public byte[]? QuestionImage { get; set; }
    public byte[]? AnswerImage { get; set; }
    public CardStats CardStats { get; set; } = new CardStats();
    public int DeckId { get; set; }
    [JsonIgnore]
    public Deck Deck { get; set; }

    public Card() {}
    
    public Card(CardAddRequest cardCreateRequest)
    {
        Question = cardCreateRequest.Question;
        Answer = cardCreateRequest.Answer;
        QuestionImage = Convert.FromBase64String(cardCreateRequest.QuestionImage ?? "");
        AnswerImage = Convert.FromBase64String(cardCreateRequest.AnswerImage ?? "");
    }

    public void UpdateLearningStats(CardStatsUpdateRequest request)
    {
        CardStats.Repetitions = request.Repetitions;
        CardStats.Interval = request.Interval;
        CardStats.EaseFactor = request.EaseFactor;
        CardStats.DueDate = DateTime.Now.AddDays(request.Interval);
    }

    public Card(CardCreateRequest request)
    {
        Question = request.Question;
        Answer = request.Answer;
        DeckId = request.DeckId;
    }

    public Card Update(CardUpdateRequest request)
    {
        Question = request.Question;
        Answer = request.Answer;
        DeckId = request.DeckId;
        return this;
    }
}
