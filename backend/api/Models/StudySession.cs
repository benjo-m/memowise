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

    public StudySession(StudySessionCreateRequest request)
    {
        UserId = request.UserId;
        DeckId = request.DeckId;
        Duration = request.Duration;
        CardCount = request.CardCount;
        AverageEaseFactor = request.AverageEaseFactor;
        AverageRepetitions = request.AverageRepetitions;
        StudiedAt = request.StudiedAt;
        CardsRated1 = request.CardsRated1;
        CardsRated2 = request.CardsRated2;
        CardsRated3 = request.CardsRated3;
        CardsRated4 = request.CardsRated4;
        CardsRated5 = request.CardsRated5;   
    }

    public StudySession Update(StudySessionUpdateRequest request)
    {
        UserId = request.UserId;
        DeckId = request.DeckId;
        Duration = request.Duration;
        CardCount = request.CardCount;
        AverageEaseFactor = request.AverageEaseFactor;
        AverageRepetitions = request.AverageRepetitions;
        StudiedAt = request.StudiedAt;
        CardsRated1 = request.CardsRated1;
        CardsRated2 = request.CardsRated2;
        CardsRated3 = request.CardsRated3;
        CardsRated4 = request.CardsRated4;
        CardsRated5 = request.CardsRated5;
        return this;
    }
}
