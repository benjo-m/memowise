using Microsoft.Data.SqlClient;
using Microsoft.ML;
using Microsoft.ML.Data;

namespace api.ML;

public class RegressionModel
{
    private readonly IConfiguration _configuration;

    public RegressionModel(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public ITransformer Train()
    {
        string modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "model.zip");

        MLContext mlContext = new MLContext();

        string sqlCommand = @"
            SELECT
                CAST(CardCount AS REAL) AS CardCount,
                CAST(Duration AS REAL) AS Duration,
                AverageEaseFactor, 
                AverageRepetitions,
                CAST(UserId AS REAL) AS UserId
            FROM StudySessions";

        DatabaseLoader loader = mlContext.Data.CreateDatabaseLoader<StudySessionData>();
        DatabaseSource dbSource = new DatabaseSource(SqlClientFactory.Instance, _configuration.GetConnectionString("MemoWiseDb") , sqlCommand);
        IDataView data = loader.Load(dbSource);

        var pipeline = mlContext.Transforms.CopyColumns(outputColumnName: "Label", inputColumnName: "Duration")
            .Append(mlContext.Transforms.Concatenate("Features", "UserId", "CardCount", "AverageEaseFactor", "AverageRepetitions"))
            .Append(mlContext.Transforms.NormalizeMinMax("Features"))
            .Append(mlContext.Regression.Trainers.FastTree());

        var model = pipeline.Fit(data);
        mlContext.Model.Save(model, data.Schema, modelPath);
        return model;
    }

    public StudySessionDurationPrediction Predict(MLContext mlContext, ITransformer model, StudySessionData studySession)
    {
        var predictionFunction = mlContext.Model.CreatePredictionEngine<StudySessionData, StudySessionDurationPrediction>(model);
        return predictionFunction.Predict(studySession);
    }
}
