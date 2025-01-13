
namespace MemoWise.Model.Models;

using MemoWise.Model.DTO;

public class UserStats
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public User User { get; set; }
    public int TotalDecksCreated { get; set; } = 0;
    public int TotalDecksGenerated { get; set; } = 0;
    public int TotalCardsCreated { get; set; } = 0;
    public int TotalCardsLearned { get; set; } = 0;
    public int StudyStreak { get; set; } = 0;
    public int LongestStudyStreak { get; set; } = 0;
    public int TotalSessionsCompleted { get; set; } = 0;
    public int TotalCorrectAnswers { get; set; } = 0;

    public UserStats()
    {
    }

    public UserStats(UserStatsCreateRequest request)
    {
        UserId = request.UserId;
        TotalDecksCreated = request.TotalDecksCreated;
        TotalDecksGenerated = request.TotalDecksGenerated;
        TotalCardsCreated = request.TotalCardsCreated;
        TotalCardsLearned = request.TotalCardsLearned;
        TotalSessionsCompleted = request.TotalSessionsCompleted;
        TotalCorrectAnswers = request.TotalCorrectAnswers;
        StudyStreak = request.StudyStreak;
        LongestStudyStreak = request.LongestStudyStreak;
    }

    public UserStats Update(UserStatsUpdateRequest request)
    {
        UserId = request.UserId;
        TotalDecksCreated = request.TotalDecksCreated;
        TotalDecksGenerated = request.TotalDecksGenerated;
        TotalCardsCreated = request.TotalCardsCreated;
        TotalCardsLearned = request.TotalCardsLearned;
        TotalSessionsCompleted = request.TotalSessionsCompleted;
        TotalCorrectAnswers = request.TotalCorrectAnswers;
        StudyStreak = request.StudyStreak;
        LongestStudyStreak = request.LongestStudyStreak;
        return this;
    }
}
