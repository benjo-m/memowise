using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;
using api.Services;

namespace api.Controllers;

[Authorize]
[Route("[controller]")]
[ApiController]
public class DecksController : ControllerBase
{
    private readonly ApplicationDbContext _dbContext;
    private readonly UserService _userService;

    public DecksController(ApplicationDbContext dbContext, UserService userService)
    {
        _dbContext = dbContext;
        _userService = userService;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Deck>> GetDeckById(int id)
    {
        var deck = await _dbContext.Decks
            .Include(d => d.Cards)
            .FirstOrDefaultAsync(d => d.Id == id);

        if (deck == null)
        {
            return NotFound();
        }

        return deck;
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> CreateDeck(DeckCreateRequest deckCreateRequest)
    {
        User? user = await _userService.GetCurrentUser(Request.Headers.Authorization);

        if (user == null)
        {
            return NotFound();
        }

        Deck deck = new Deck(deckCreateRequest);
        deck.User = user;

        _dbContext.Decks.Add(deck);
        await _dbContext.SaveChangesAsync();

        return Created();
    }

    [HttpPatch("{id}")]
    public async Task<IActionResult> UpdateDeck(int id, DeckUpdateRequest deckUpdateRequest)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(id);

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
        User? user = await _userService.GetCurrentUser(Request.Headers.Authorization);

        if (deck == null)
        {
            return NotFound();
        }
        else if (user == null || user.Id != deck.UserId)
        {
            return Forbid();
        }

        _dbContext.Decks.Remove(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    [HttpGet("user/{firebaseUid}")]
    public async Task<ActionResult<List<DeckSummary>>> GetDecksByUser(string firebaseUid)
    {
        var decks = await _dbContext.Decks
            .Where(x => x.User.FirebaseUid == firebaseUid)
            .Include(x => x.Cards)
            .ToListAsync();

        var deckSummaries = decks.Select(deck => new DeckSummary(deck)).ToList();

        return deckSummaries;
    }

    [HttpGet("{deckId}/cards")]
    public async Task<ActionResult<List<Card>>> GetCardsByDeck(int deckId)
    {
        var cards = await _dbContext.Decks
            .Where(x => x.Id == deckId)
            .SelectMany(x => x.Cards)
            .ToListAsync();

        return Ok(cards);
    }

    [HttpPost("{deckId}/cards")]
    public async Task<IActionResult> AddCard(int deckId, CardCreateRequest cardCreateRequest) 
    {
        Card card = new Card(cardCreateRequest);
        card.Deck = await _dbContext.Decks.FirstAsync(x => x.Id == deckId);

        _dbContext.Add(card);
        await _dbContext.SaveChangesAsync();

        return Ok();
    }

    [HttpPatch("{deckId}/cards/{cardId}")]
    public async Task<IActionResult> EditCard(int deckId, int cardId, CardUpdateRequest cardUpdateRequest)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.DeckId == deckId && c.Id == cardId)
            .FirstOrDefaultAsync();

        if (card == null)
        {
            return NotFound();
        }

        card.Question = cardUpdateRequest.Question;
        card.Answer = cardUpdateRequest.Answer;

        _dbContext.Update(card);
        await _dbContext.SaveChangesAsync();

        return Ok();
    }
}
