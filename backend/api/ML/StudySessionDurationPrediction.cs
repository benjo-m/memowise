using Microsoft.ML.Data;

namespace api.ML;

public class StudySessionDurationPrediction
{
    [ColumnName("Score")]
    public float Duration { get; set; }
}
