using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;

namespace api.Controllers;

[Route("api/[controller]")]
[ApiController]
public class DecksController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public DecksController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Deck>>> GetDeck()
    {
        return await _context.Decks.ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Deck>> GetDeck(int id)
    {
        var deck = await _context.Decks.FindAsync(id);

        if (deck == null)
        {
            return NotFound();
        }

        return deck;
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> PostDeck(DeckCreateRequest request)
    {
        Deck deck = new Deck(request);
        User? user = await _context.Users.FindAsync(request.UserId);

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
    public async Task<IActionResult> UpdateDeck(int id, DeckUpdateRequest request)
    {
        Deck? deck = await _context.Decks.FindAsync(id);

        if (deck == null) return NotFound();

        deck.Name = request.Name;

        _context.Decks.Update(deck);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteDeck(int id)
    {
        var deck = await _context.Decks.FindAsync(id);
        if (deck == null)
        {
            return NotFound();
        }

        _context.Decks.Remove(deck);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
