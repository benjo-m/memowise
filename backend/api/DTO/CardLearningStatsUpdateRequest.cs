using System.Text.Json.Serialization;

namespace api.DTO;

public class CardLearningStatsUpdateRequest
{
    public int Id { get; set; }

    public float EaseFactor { get; set; } 
    public int Interval { get; set; }
    public int Repetitions { get; set; }

    public CardLearningStatsUpdateRequest(int id, float easeFactor, int interval, int repetitions)
    {
        Id = id;
        EaseFactor = easeFactor;
        Interval = interval;
        Repetitions = repetitions;
    }
}
