using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;

namespace api.Controllers;

[Route("api/decks")]
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

    [HttpPut("{id}")]
    public async Task<IActionResult> PutDeck(int id, Deck deck)
    {
        if (id != deck.Id)
        {
            return BadRequest();
        }

        _context.Entry(deck).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!DeckExists(id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> PostDeck(Deck deck)
    {
        _context.Decks.Add(deck);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetDeck", new { id = deck.Id }, deck);
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

    private bool DeckExists(int id)
    {
        return _context.Decks.Any(e => e.Id == id);
    }
}
