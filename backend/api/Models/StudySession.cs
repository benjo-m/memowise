using api.DTO;

namespace api.Models;

public class StudySession
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int DeckId { get; set; }
    public Deck Deck { get; set; }
    public int Duration { get; set; }
    public int CardCount { get; set; }
    public float AverageEaseFactor { get; set; }
    public float AverageRepetitions { get; set; }
    public DateTime StudiedAt { get; set; }
    public int CardsRated1 { get; set; }
    public int CardsRated2 { get; set; }
    public int CardsRated3 { get; set; }
    public int CardsRated4 { get; set; }
    public int CardsRated5 { get; set; }

    public StudySession() {}

    public StudySession(StudySessionCreateRequest studySessionCreateRequest)
    {
        UserId = studySessionCreateRequest.UserId;
        DeckId = studySessionCreateRequest.DeckId;
        Duration = studySessionCreateRequest.Duration;
        CardCount = studySessionCreateRequest.CardCount;
        AverageEaseFactor = studySessionCreateRequest.AverageEaseFactor;
        AverageRepetitions = studySessionCreateRequest.AverageRepetitions;
        StudiedAt = studySessionCreateRequest.StudiedAt;
        CardsRated1 = studySessionCreateRequest.CardsRated1;
        CardsRated2 = studySessionCreateRequest.CardsRated2;
        CardsRated3 = studySessionCreateRequest.CardsRated3;
        CardsRated4 = studySessionCreateRequest.CardsRated4;
        CardsRated5 = studySessionCreateRequest.CardsRated5;
        
    }
}
