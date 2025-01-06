namespace api.DTO;

public class UserStatsCreateRequest
{
    public int UserId { get; set; }
    public int TotalDecksCreated { get; set; }
    public int TotalDecksGenerated { get; set; }
    public int TotalCardsCreated { get; set; }
    public int TotalCardsLearned { get; set; }
    public int StudyStreak { get; set; }
    public int LongestStudyStreak { get; set; }
    public int TotalSessionsCompleted { get; set; }
    public int TotalCorrectAnswers { get; set; }
}
