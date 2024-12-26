namespace api.DTO;

public class StatsResponse
{
    public int TotalDecksCreated { get; set; }
    public int TotalDecksCreatedManually { get; set; }
    public int TotalDecksGenerated { get; set; }
    public List<MostStudiedDeck> MostStudiedDecks { get; set; }
    public double AverageDeckSize { get; set; }
    public int TotalCardsCreated { get; set; }
    public int TotalCardsLearned { get; set; }
    public int TotalCardsRated1 { get; set; }
    public int TotalCardsRated2 { get; set; }
    public int TotalCardsRated3 { get; set; }
    public int TotalCardsRated4 { get; set; }
    public int TotalCardsRated5 { get; set; }
    public int TimeSpentStudying { get; set; }
    public int CurrentStudyStreak { get; set; }
    public int LongestStudyStreak { get; set; }
    public int LongestStudySession { get; set; }
    public double AverageStudySessionDuration { get; set; }
}
