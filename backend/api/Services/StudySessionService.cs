using api.Data;
using api.DTO;
using api.ML;
using api.Models;
using Microsoft.ML;

namespace api.Services;

public class StudySessionService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly StudySessionDurationService _studySessionDurationService;

    public StudySessionService(ApplicationDbContext dbContext, StudySessionDurationService studySessionDurationService)
    {
        _dbContext = dbContext;
        _studySessionDurationService = studySessionDurationService;
    }

    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        var studySession = new StudySession(studySessionCreateRequest);

        _dbContext.StudySessions.Add(studySession);
        await _dbContext.SaveChangesAsync();
    }

    public StudySessionDurationPrediction PredictStudySessionDuration(StudySessionDurationInput studySessionDurationInput)
    {
        var mlContext = new MLContext();
        DataViewSchema modelSchema;
        ITransformer model;
        string modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ML", "model.zip");

        if (File.Exists(modelPath))
        {
            model = mlContext.Model.Load(modelPath, out modelSchema);
        }
        else
        {
            model = _studySessionDurationService.Train();
        }

        return _studySessionDurationService.TestSinglePrediction(mlContext, model, studySessionDurationInput);
    }
}
