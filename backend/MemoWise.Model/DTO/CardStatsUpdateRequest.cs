namespace MemoWise.Model.DTO;

public class CardStatsUpdateRequest
{
    public int CardId { get; set; }
    public float EaseFactor { get; set; } 
    public int Interval { get; set; }
    public int Repetitions { get; set; }
    public DateTime DueDate { get; set; }

    public CardStatsUpdateRequest() {}

    public CardStatsUpdateRequest(int id, float easeFactor, int interval, int repetitions, DateTime dueDate)
    {
        CardId = id;
        EaseFactor = easeFactor;
        Interval = interval;
        Repetitions = repetitions;
        DueDate = dueDate;
    }
}
