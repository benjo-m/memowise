using api.Data;
using api.DTO;
using api.Exceptions;
using api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class DeckService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly UserService _userService;
    private readonly StudySessionService _studySessionService;

    public DeckService(ApplicationDbContext dbContext, UserService userService, StudySessionService studySessionService)
    {
        _dbContext = dbContext;
        _userService = userService;
        _studySessionService = studySessionService;
    }

    public async Task<List<DeckSummary>> GetDecksByUser(int userId)
    {
        var currentUser = await _userService.GetCurrentUser();

        if (currentUser!.Id != userId)
        {
            throw new ResourceForbiddenException("Cannot access this deck");
        }

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

    public async Task<Deck?> GetDeckById(int deckId)
    {
        return await _dbContext.Decks
            .Include(d => d.Cards)
            .ThenInclude(c => c.CardStats)
            .FirstOrDefaultAsync(d => d.Id == deckId);
    }

    public async Task<Deck?> CreateDeck(DeckCreateRequest deckCreateRequest)
    {
        User? user = await _userService.GetCurrentUser();

        if (user == null)
        {
            return null;
        }

        Deck deck = new Deck(deckCreateRequest);
        deck.User = user;

        _dbContext.Decks.Add(deck);
        await _dbContext.SaveChangesAsync();

        return deck;
    }

    public async Task<Deck?> UpdateDeck(int deckId, DeckUpdateRequest deckUpdateRequest)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(deckId);

        if (deck == null)
        {
            return null;
        }

        deck.Name = deckUpdateRequest.Name;

        _dbContext.Decks.Update(deck);
        await _dbContext.SaveChangesAsync();

        return deck;
    }

    public async Task<Deck?> DeleteDeck(int deckId)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(deckId);

        if (deck == null)
        {
            return null;
        }

        _dbContext.Decks.Remove(deck);
        await _dbContext.SaveChangesAsync();

        return deck;
    }
}
