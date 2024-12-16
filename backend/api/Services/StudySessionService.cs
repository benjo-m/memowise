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

    public StudySessionDurationPrediction PredictStudySessionDuration(Deck deck, int userId)
    {
        var mlContext = new MLContext();
        DataViewSchema modelSchema;
        ITransformer model;
        string modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "model.zip");
        StudySessionData studySessionData = StudySessionDataFromDeck(deck, userId);

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

    public void GenerateMockStudySessions()
    {
        var random = new Random();
        var mockData = new List<StudySession>();

        // Generate 100 realistic study sessions
        for (int i = 0; i < 500; i++)
        {
            var cardCount = random.Next(10, 51); // 10 to 50 cards per session
            var easeFactor = (float)Math.Round((random.NextDouble() * 1.4 + 1.3), 2); // Ease factor between 1.3 and 2.7

            // Duration correlates with card count and ease factor
            var duration = (int)((cardCount * 3) * (2.7 - easeFactor) * random.Next(15, 30)); // Adjusting range and scaling


            // Repetitions will be somewhat correlated with ease factor (higher ease factor = fewer repetitions)
            float repetitions = (float)Math.Round(random.NextDouble() * 2.7 + 1.3, 2); // Between 1 and 5

            var studySession = new StudySession
            {
                UserId = random.Next(10, 20), // Random user ID between 1 and 10
                CardCount = cardCount,
                Duration = duration,
                AverageEaseFactor = easeFactor,
                AverageRepetitions = repetitions,
                StudiedAt = DateTime.Now.AddDays(-random.Next(1, 30)).AddHours(-random.Next(1, 24)) // Random date within the last 30 days
            };

            mockData.Add(studySession);
        }

        _dbContext.StudySessions.AddRange(mockData);
        _dbContext.SaveChanges();
    }
}
