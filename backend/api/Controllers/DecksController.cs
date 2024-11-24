using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;

namespace api.Controllers;

[Route("[controller]")]
[ApiController]
public class DecksController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public DecksController(ApplicationDbContext context)
    {
        _context = context;
    }

    
    [HttpGet("{id}")]
    [Authorize]
    public async Task<ActionResult<Deck>> GetDeckById(int id)
    {
        var deck = await _context.Decks.FindAsync(id);

        if (deck == null)
        {
            return NotFound();
        }

        return deck;
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> PostDeck(DeckCreateRequest deckCreateRequest)
    {
        Deck deck = new Deck(deckCreateRequest);
        User? user = await _context.Users.FindAsync(deckCreateRequest.UserId);

        if (user == null)
        {
            return NotFound();
        }

        deck.User = user;

        _context.Decks.Add(deck);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetDeck", new { id = deck.Id }, deck);
    }

    [HttpPatch("{id}")]
    public async Task<IActionResult> UpdateDeck(int id, DeckUpdateRequest deckUpdateRequest)
    {
        Deck? deck = await _context.Decks.FindAsync(id);

        if (deck == null)
        {
            return NotFound();
        }

        deck.Name = deckUpdateRequest.Name;

        _context.Decks.Update(deck);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteDeck(int id)
    {
        Deck? deck = await _context.Decks.FindAsync(id);

        if (deck == null)
        {
            return NotFound();
        }

        _context.Decks.Remove(deck);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<List<Deck>>> GetDecksByUserId(int userId)
    {
        var decks = await _context.Decks
            .Where(x => x.UserId == userId)
            .ToListAsync();

        return decks;
    }
    
    [HttpGet("{deckId}/cards")]
    public async Task<ActionResult<List<Card>>> GetCardsByDeckId(int deckId)
    {
        var cards = await _context.Decks
            .Where(x => x.Id == deckId)
            .SelectMany(x => x.Cards)
            .ToListAsync();

        return Ok(cards);
    }

    [HttpPost("{deckId}/cards")]
    public async Task<IActionResult> AddCard(int deckId, CardCreateRequest cardCreateRequest) 
    {
        Card card = new Card(cardCreateRequest);
        card.Deck = await _context.Decks.FirstAsync(x => x.Id == deckId);

        _context.Add(card);
        await _context.SaveChangesAsync();

        return Ok();
    }
}
