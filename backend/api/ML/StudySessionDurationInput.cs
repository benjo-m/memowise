namespace api.ML;

public class StudySessionDurationInput
{
    public string FirebaseUserUid { get; set; }
    public float CardCount { get; set; }
    public float Duration { get; set; }
    public float AverageEaseFactor { get; set; }
    public float AverageRepetitions { get; set; }
    public DateTime StudiedAt { get; set; }
}
