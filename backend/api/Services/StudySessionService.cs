using api.Data;
using api.DTO;
using api.ML;
using api.Models;
using Microsoft.ML;

namespace api.Services;

public class StudySessionService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly RegressionModel _regressionModel;
    private readonly UserService _userService;

    public StudySessionService(ApplicationDbContext dbContext, RegressionModel regressionModel, UserService userService)
    {
        _dbContext = dbContext;
        _regressionModel = regressionModel;
        _userService = userService;
    }

    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        var studySession = new StudySession(studySessionCreateRequest);

        _dbContext.StudySessions.Add(studySession);
        await _dbContext.SaveChangesAsync();
    }

    public async Task<StudySessionDurationPrediction> PredictStudySessionDuration(Deck deck)
    {
        var mlContext = new MLContext();
        DataViewSchema modelSchema;
        ITransformer model;
        string modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ML", "model.zip");
        StudySessionData studySessionData = await StudySessionDataFromDeck(deck);

        if (File.Exists(modelPath))
        {
            model = mlContext.Model.Load(modelPath, out modelSchema);
        }
        else
        {
            model = _regressionModel.Train();
        }

        return _regressionModel.Predict(mlContext, model, studySessionData);
    }

    private async Task<StudySessionData> StudySessionDataFromDeck(Deck deck)
    {
        User? user = await _userService.GetCurrentUser();

        float sumEf = 0f;
        float sumReps = 0f;
        int cardCount = 0;

        foreach (var card in deck.Cards)
        {
            if ((card.CardStats.Interval > 0 && DateTime.Compare(card.CardStats.DueDate, DateTime.Now) < 0) ||
                card.CardStats.Interval == 0)
            {
                cardCount++;
                sumEf += card.CardStats.EaseFactor;
                sumReps += card.CardStats.Repetitions;
            }
        }

        var studySessionData = new StudySessionData()
        {
            FirebaseUserUid = user!.FirebaseUid,
            CardCount = cardCount,
            Duration = 0,
            AverageEaseFactor = sumEf / cardCount,
            AverageRepetitions = sumReps / cardCount,
            StudiedAt = DateTime.Now,
        };
        return studySessionData;
    }
}
