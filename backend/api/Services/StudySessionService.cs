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
    private readonly UserService _userService;

    public StudySessionService(ApplicationDbContext dbContext, StudySessionDurationService studySessionDurationService, UserService userService)
    {
        _dbContext = dbContext;
        _studySessionDurationService = studySessionDurationService;
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
        StudySessionDurationInput studySessionDurationInput = await StudySessionDurationInputFromDeck(deck);

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

    private async Task<StudySessionDurationInput> StudySessionDurationInputFromDeck(Deck deck)
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

        var studySessionDurationInput = new StudySessionDurationInput()
        {
            FirebaseUserUid = user!.FirebaseUid,
            CardCount = cardCount,
            Duration = 0,
            AverageEaseFactor = sumEf / cardCount,
            AverageRepetitions = sumReps / cardCount,
            StudiedAt = DateTime.Now,
        };
        return studySessionDurationInput;
    }
}
