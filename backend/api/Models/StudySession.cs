using api.DTO;

namespace api.Models;

public class StudySession
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int Duration { get; set; }
    public int CardCount { get; set; }
    public float AverageEaseFactor { get; set; }
    public float AverageRepetitions { get; set; }
    public DateTime StudiedAt { get; set; }

    public StudySession() {}

    public StudySession(StudySessionCreateRequest studySessionCreateRequest)
    {
        UserId = studySessionCreateRequest.UserId;
        Duration = studySessionCreateRequest.Duration;
        CardCount = studySessionCreateRequest.CardCount;
        AverageEaseFactor = studySessionCreateRequest.AverageEaseFactor;
        AverageRepetitions = studySessionCreateRequest.AverageRepetitions;
        StudiedAt = studySessionCreateRequest.StudiedAt;
    }
}
