using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;
using api.Services;

namespace api.Controllers;

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
    [Authorize]
    public async Task<ActionResult<Deck>> GetDeckById(int id)
    {
        var deck = await _dbContext.Decks.FindAsync(id);

        if (deck == null) return NotFound();

        return deck;
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> CreateDeck(DeckCreateRequest deckCreateRequest)
    {
        string token = Request.Headers.Authorization
            .ToString()
            .Substring("Bearer ".Length);

        User? user = await _userService.GetCurrentUser(token);

        if (user == null) return NotFound();

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

        if (deck == null) return NotFound();

        deck.Name = deckUpdateRequest.Name;

        _dbContext.Decks.Update(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteDeck(int id)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(id);

        if (deck == null)
        {
            return NotFound();
        }

        _dbContext.Decks.Remove(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    [Authorize]
    [HttpGet("user/{firebaseUid}")]
    public async Task<ActionResult<List<Deck>>> GetDecksByUser(string firebaseUid)
    {
        var decks = await _dbContext.Decks
            .Where(x => x.User.FirebaseUid == firebaseUid)
            .Include(x => x.Cards)
            .ToListAsync();

        return decks;
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
}
