using Microsoft.ML;

namespace api.ML;

public class StudySessionDurationService
{
    public ITransformer Train()
    {
        string dataPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ML", "training-data.csv");
        string modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ML", "model.zip");

        MLContext mlContext = new MLContext();

        IDataView dataView = mlContext.Data.LoadFromTextFile<StudySessionDataView>(dataPath, hasHeader: true, separatorChar: ',');

        var pipeline = mlContext.Transforms.CopyColumns(outputColumnName: "Label", inputColumnName: "Duration")
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "FirebaseUserUidEncoded", inputColumnName: "FirebaseUserUid"))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "StudiedAtEncoded", inputColumnName: "StudiedAt"))
            .Append(mlContext.Transforms.Concatenate("Features", "FirebaseUserUidEncoded", "CardCount", "AverageEaseFactor", "AverageRepetitions", "StudiedAtEncoded"))
            .Append(mlContext.Transforms.NormalizeMinMax("Features"))
            .Append(mlContext.Regression.Trainers.FastTree());

        var model = pipeline.Fit(dataView);

        mlContext.Model.Save(model, dataView.Schema, modelPath);

        return model;
    }

    public StudySessionDurationPrediction TestSinglePrediction(MLContext mlContext, ITransformer model, StudySessionDurationInput studySession)
    {
        var predictionFunction = mlContext.Model.CreatePredictionEngine<StudySessionDurationInput, StudySessionDurationPrediction>(model);

        return predictionFunction.Predict(studySession);
    }
}
