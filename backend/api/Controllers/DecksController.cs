using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;
using api.Services;
using System.Text.Json.Nodes;
using api.Groq;
using Newtonsoft.Json;

namespace api.Controllers;

[Authorize]
[Route("api/[controller]")]
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

    [HttpGet("{deckId}")]
    public async Task<ActionResult<Deck>> GetDeckById(int deckId)
    {
        var deck = await _dbContext.Decks
            .Include(d => d.Cards)
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
        User? user = await _userService.GetCurrentUser(Request.Headers.Authorization);

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
        return await _dbContext.Decks
            .Where(x => x.User.FirebaseUid == firebaseUid)
            .Include(x => x.Cards)
            .Select(deck => new DeckSummary(deck))
            .ToListAsync();
    }
}
