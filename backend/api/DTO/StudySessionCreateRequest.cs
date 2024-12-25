namespace api.DTO;

public class StudySessionCreateRequest
{
    public int UserId { get; set; }
    public int DeckId { get; set; }
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
}
