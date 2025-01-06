namespace api.DTO;

public class AnalyticsData
{
    // Users
    public int TotalUsers { get; set; }
    public int TotalPremiumUsers { get; set; }
    public int MonthlyActiveUsers { get; set; }
    public int DailyActiveUsers { get; set; }
    public List<NewUsersByMonth> NewUsersByMonth { get; set; }
    public UserDistributionResponse UserDistribution { get; set; }
    public UserGrowthResponse UserGrowth { get; set; }
    // Decks & Cards
    public int TotalDecksCreated { get; set; }
    public int TotalCardsCreated { get; set; }
    public double AverageDecksPerUser => Math.Round((TotalDecksCreated / (double)TotalUsers), 2);
    public double AverageCardsPerUser => Math.Round((TotalCardsCreated / (double)TotalUsers), 2);
    public double AverageEaseFactor { get; set; }
    public double ManuallyCreatedDecksPercentage { get; set; }
    public double GeneratedDecksPercentage { get; set; }
    // Study Sessions
    public int TotalStudySessions { get; set; }
    public int TotalTimeSpentStudying { get; set; }
    public double AverageSessionDuration { get; set; }
    public double AverageStudyStreak { get; set; }
    public int LongestStudyStreak { get; set; }
    public List<StudySessionSegment> StudySessionSegments { get; set; }
    // Achievements
    public List<AchievementUnlockPercentage> AchievementUnlockPercentages { get; set; }
}
