using api.Data;
using MemoWise.Model.DTO;
using api.ML;
using MemoWise.Model.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML; 

namespace api.Services;

public class StudySessionService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly RegressionModel _regressionModel;
    private readonly AchievementsService _achievementService;

    private static readonly MLContext _mlContext = new MLContext();
    private static ITransformer _model;
    private static readonly object _modelLock = new object();
    private readonly string _modelPath;


    public StudySessionService(ApplicationDbContext dbContext, RegressionModel regressionModel, UserService userService, AchievementsService achievementService) : base(dbContext)
    {
        _dbContext = dbContext;
        _regressionModel = regressionModel;
        _modelPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "model.zip");
        LoadModel();
        _achievementService = achievementService;
    }

    public async Task<PaginatedResponse<StudySessionDto>> GetAllStudySessions
    (int page, int pageSize, string? sortBy, bool sortDescending, int? deck, int? user)
    {
        var query = _dbContext.StudySessions
            .Select(session => new StudySessionDto
            {
                Id = session.Id,
                UserId = session.UserId,
                DeckId = session.DeckId,
                CardCount = session.CardCount,
                Duration = session.Duration,
                AverageEaseFactor = session.AverageEaseFactor,
                AverageRepetitions = session.AverageRepetitions,
                StudiedAt = session.StudiedAt,
                CardsRated1 = session.CardsRated1,
                CardsRated2 = session.CardsRated2,
                CardsRated3 = session.CardsRated3,
                CardsRated4 = session.CardsRated4,
                CardsRated5 = session.CardsRated5
            });

        if (deck != null)
        {
            query = query.Where(c => c.DeckId == deck);
        }

        if (user != null)
        {
            query = query.Where(c => c.UserId == user);
        }

        query = sortBy switch
        {
            "duration" => sortDescending ? query.OrderByDescending(c => c.Duration) : query.OrderBy(c => c.Duration),
            "cardCount" => sortDescending ? query.OrderByDescending(c => c.CardCount) : query.OrderBy(c => c.CardCount),
            "avgEaseFactor" => sortDescending ? query.OrderByDescending(c => c.AverageEaseFactor) : query.OrderBy(c => c.AverageEaseFactor),
            "avgRepetitions" => sortDescending ? query.OrderByDescending(c => c.AverageRepetitions) : query.OrderBy(c => c.AverageRepetitions),
            "user" => sortDescending ? query.OrderByDescending(c => c.UserId) : query.OrderBy(c => c.UserId),
            "deck" => sortDescending ? query.OrderByDescending(c => c.DeckId) : query.OrderBy(c => c.DeckId),
            "cr1" => sortDescending ? query.OrderByDescending(ss => ss.CardsRated1) : query.OrderBy(query => query.CardsRated1),
            "cr2" => sortDescending ? query.OrderByDescending(ss => ss.CardsRated2) : query.OrderBy(query => query.CardsRated2),
            "cr3" => sortDescending ? query.OrderByDescending(ss => ss.CardsRated3) : query.OrderBy(query => query.CardsRated3),
            "cr4" => sortDescending ? query.OrderByDescending(ss => ss.CardsRated4) : query.OrderBy(query => query.CardsRated4),
            "cr5" => sortDescending ? query.OrderByDescending(ss => ss.CardsRated5) : query.OrderBy(query => query.CardsRated5),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var studySessions = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<StudySessionDto>(studySessions, page, totalPages);
    }

    public async Task<int> CompleteStudySession(StudySessionCreateRequest studySessionCreateRequest)
    {
        var deck = _dbContext.Decks.First(d => d.Id == studySessionCreateRequest.DeckId);
        var studySession = new StudySession(studySessionCreateRequest);
        studySession.Deck = deck;

        int studyStreak = await UpdateUserStats(studySession);

        _dbContext.StudySessions.Add(studySession);
        await _dbContext.SaveChangesAsync();

        await _achievementService.CheckAchievements(studySession.UserId);

        return studyStreak;
    }

    private async Task<int> UpdateUserStats(StudySession studySession)
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
            if (user.UserStats.StudyStreak > user.UserStats.LongestStudyStreak)
            {
                user.UserStats.LongestStudyStreak = user.UserStats.StudyStreak;
            }
        }

        user.UserStats.TotalSessionsCompleted++;
        user.UserStats.TotalCardsLearned += studySession.CardCount;
        user.UserStats.TotalCorrectAnswers += studySession.CardCount;

        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();

        return user.UserStats.StudyStreak;
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
