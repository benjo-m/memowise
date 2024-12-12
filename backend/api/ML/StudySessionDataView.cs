using Microsoft.ML.Data;

namespace api.ML;

public class StudySessionDataView
{
    [LoadColumn(0)]
    public string FirebaseUserUid { get; set; }
    [LoadColumn(1)]
    public float CardCount { get; set; }
    [LoadColumn(2)]
    public float Duration { get; set; }
    [LoadColumn(3)]
    public float AverageEaseFactor { get; set; }
    [LoadColumn(4)]
    public float AverageRepetitions { get; set; }
    [LoadColumn(5)]
    public DateTime StudiedAt { get; set; }
}
