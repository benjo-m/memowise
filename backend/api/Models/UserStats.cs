namespace api.Models;

public class UserStats
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public User User { get; set; }
    public int TotalDecksCreated { get; set; } = 0;
    public int TotalCardsCreated { get; set; } = 0;
    public int TotalCardsLearned { get; set; } = 0;
    public int StudyStreak { get; set; } = 0;
    public int TotalSessionsCompleted { get; set; } = 0;
    public int TotalCorrectAnswers { get; set; } = 0;
}
