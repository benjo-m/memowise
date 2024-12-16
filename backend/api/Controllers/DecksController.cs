using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;
using api.Services;
using System.Security.Claims;

namespace api.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class DecksController : ControllerBase
{
    private readonly ApplicationDbContext _dbContext;
    private readonly UserService _userService;
    private readonly StudySessionService _studySessionService;

    public DecksController(ApplicationDbContext dbContext, UserService userService, StudySessionService studySessionService)
    {
        _dbContext = dbContext;
        _userService = userService;
        _studySessionService = studySessionService;
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<List<DeckSummary>>> GetDecksByUser(int userId)
    {
        var authenticatedUserId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (int.Parse(authenticatedUserId!) != userId)
        {
            return Forbid();
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

    [HttpGet("{deckId}")]
    public async Task<ActionResult<Deck>> GetDeckById(int deckId)
    {
        var deck = await _dbContext.Decks
            .Include(d => d.Cards)
            .ThenInclude(c => c.CardStats)
            .FirstOrDefaultAsync(d => d.Id == deckId);

        if (deck == null)
        {
            return NotFound();
        }

        return deck;
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> CreateDeck(DeckCreateRequest deckCreateRequest)
    {
        User? user = await _userService.GetCurrentUser();

        if (user == null)
        {
            return NotFound();
        }

        Deck deck = new Deck(deckCreateRequest);
        deck.User = user;

        _dbContext.Decks.Add(deck);
        await _dbContext.SaveChangesAsync();

        return deck;
    }

    [HttpPatch("{deckId}")]
    public async Task<IActionResult> UpdateDeck(int deckId, DeckUpdateRequest deckUpdateRequest)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(deckId);

        if (deck == null)
        {
            return NotFound();
        }

        deck.Name = deckUpdateRequest.Name;

        _dbContext.Decks.Update(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{deckId}")]
    public async Task<IActionResult> DeleteDeck(int deckId)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(deckId);

        if (deck == null)
        {
            return NotFound();
        }

        _dbContext.Decks.Remove(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }
}
