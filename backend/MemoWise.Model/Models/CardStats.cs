using System.Text.Json.Serialization;
using MemoWise.Model.DTO;

namespace MemoWise.Model.Models;
public class CardStats
{
    public int Id { get; set; }
    public int Repetitions { get; set; } = 0;
    public int Interval { get; set; } = 0;
    public float EaseFactor { get; set; } = 2.5f;
    public DateTime DueDate { get; set; } = DateTime.Now;
    public int CardId { get; set; }
    [JsonIgnore]
    public Card Card { get; set; }

    public CardStats()
    {
    }

    public CardStats(CardStatsCreateRequest request)
    {
        Repetitions = request.Repetitions;
        Interval = request.Interval;
        EaseFactor = request.EaseFactor;
        CardId = request.CardId;
        DueDate = request.DueDate;
    }

    public CardStats Update(CardStatsUpdateRequestAdmin request)
    {
        CardId = request.CardId;
        EaseFactor = request.EaseFactor;
        Interval = request.Interval;
        DueDate = request.DueDate;
        Repetitions = request.Repetitions;
        return this;
    }
}
