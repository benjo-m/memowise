using api.Data;
using MemoWise.Model.DTO;
using api.Exceptions;
using MemoWise.Model.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class DeckService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly AuthService _authService;
    private readonly StudySessionService _studySessionService;

    public DeckService(ApplicationDbContext dbContext, StudySessionService studySessionService, AuthService authService) : base(dbContext)
    {
        _dbContext = dbContext;
        _studySessionService = studySessionService;
        _authService = authService;
    }

    public async Task<PaginatedResponse<DeckDto>> GetAllDecks
        (int page, int pageSize, string? sortBy, bool sortDescending, int? user)
    {
        var query = _dbContext.Decks
            .Select(deck => new DeckDto
            {
                Id = deck.Id,
                Name = deck.Name, 
                UserId = deck.UserId
            });

        if (user != null)
        {
            query = query.Where(d => d.UserId == user);
        }

        query = sortBy switch
        {
            "name" => sortDescending ? query.OrderByDescending(d => d.Name) : query.OrderBy(d => d.Name),
            "user" => sortDescending ? query.OrderByDescending(d => d.UserId) : query.OrderBy(d => d.UserId),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var decks = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<DeckDto>(decks, page, totalPages);
    }

    public async Task<List<DeckSummary>> GetDecksByUser(int userId)
    {
        var decks = await _dbContext.Decks
            .Where(x => x.User.Id == userId)
            .Include(x => x.Cards)
            .ThenInclude(c => c.CardStats)
            .ToListAsync();

        var deckSummaries = new List<DeckSummary>();

        foreach (var deck in decks)
        {
            var deckSummary = new DeckSummary(deck);
            var duration = _studySessionService.PredictStudySessionDuration(deck, userId);
            deckSummary.TimeToComplete = (int)duration.Duration;
            deckSummaries.Add(deckSummary);
        }

        return deckSummaries;
    }

    public async Task<Deck?> GetDeckWithCards(int deckId)
    {
        return await _dbContext.Decks
            .Include(d => d.Cards)
            .ThenInclude(c => c.CardStats)
            .FirstOrDefaultAsync(d => d.Id == deckId);
    }

    public async Task<Deck?> CreateDeckWithCards(DeckCreateRequestWithCards deckCreateRequest)
    {
        User? user = await _authService.GetCurrentUser();

        if (user == null)
        {
            return null;
        }

        var currentDeckCount = _dbContext.Decks
            .Where(d => d.UserId ==  user.Id)
            .Count();

        if (!user.IsPremium && currentDeckCount == 10)
        {
            throw new NonPremiumLimitException("Deck limit exceeded");
        }

        Deck deck = new Deck(deckCreateRequest);
        deck.User = user;

        user.UserStats.TotalDecksCreated++;
        user.UserStats.TotalCardsCreated += deck.Cards.Count();

        _dbContext.Decks.Add(deck);
        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();

        return deck;
    }
}
