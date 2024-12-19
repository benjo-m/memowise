using api.Data;
using api.DTO;
using api.ML;
using api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;

namespace api.Services;

public class StudySessionService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly RegressionModel _regressionModel;
    private readonly AchievementsService _achievementService;

    private static readonly MLContext _mlContext = new MLContext();
    private static ITransformer _model;
    private static readonly object _modelLock = new object();
    private readonly string _modelPath;


    public StudySessionService(ApplicationDbContext dbContext, RegressionModel regressionModel, UserService userService, AchievementsService achievementService)
    {
        _dbContext = dbContext;
        _regressionModel = regressionModel;
        _modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "model.zip");
        LoadModel();
        _achievementService = achievementService;
    }

    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        var studySession = new StudySession(studySessionCreateRequest);

        await UpdateUserStats(studySession);

        _dbContext.StudySessions.Add(studySession);
        await _dbContext.SaveChangesAsync();

        await _achievementService.CheckAchievements(studySession.UserId);
    }

    private async Task UpdateUserStats(StudySession studySession)
    {
        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .SingleAsync(u => u.Id == studySession.UserId);

        var lastStudySession = await _dbContext.StudySessions
            .Where(ss => ss.UserId == user!.Id)
            .OrderByDescending(ss => ss.StudiedAt)
            .FirstOrDefaultAsync();

        if (lastStudySession == null || lastStudySession.StudiedAt.Date != DateTime.Today)
        {
            user.UserStats.StudyStreak++;
        }

        user.UserStats.TotalSessionsCompleted++;
        user.UserStats.TotalCardsLearned += studySession.CardCount;
        user.UserStats.TotalCorrectAnswers += studySession.CardCount;

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
    }

    private void LoadModel()
    {
        if (_model != null)
            return;

        lock (_modelLock)
        {
            if (_model == null)
            {
                if (File.Exists(_modelPath))
                {
                    _model = _mlContext.Model.Load(_modelPath, out _);
                }
                else
                {
                    _model = _regressionModel.Train();
                }
            }
        }
    }

    public StudySessionDurationPrediction PredictStudySessionDuration(Deck deck, int userId)
    {
        StudySessionData studySessionData = StudySessionDataFromDeck(deck, userId);

        return _regressionModel.Predict(_mlContext, _model, studySessionData);
    }

    private StudySessionData StudySessionDataFromDeck(Deck deck, int userId)
    {
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
            UserId = userId,
            CardCount = cardCount,
            Duration = 0,
            AverageEaseFactor = sumEf / cardCount,
            AverageRepetitions = sumReps / cardCount,
        };
        return studySessionData;
    }
}
