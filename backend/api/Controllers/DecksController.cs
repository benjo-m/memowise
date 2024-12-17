using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;
using api.Services;
using System.Security.Claims;
using api.Exceptions;

namespace api.Controllers;

public class DecksController : BaseController
{
    private readonly DeckService _deckService;

    public DecksController(DeckService deckService)
    {
        _deckService = deckService;
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<List<DeckSummary>>> GetDecksByUser(int userId)
    {
        try
        {
            var decks = await _deckService.GetDecksByUser(userId);
            return Ok(decks);
        }
        catch (ResourceForbiddenException)
        {
            return Forbid();
        }
    }

    [HttpGet("{deckId}")]
    public async Task<ActionResult<Deck>> GetDeckById(int deckId)
    {
        var deck = await _deckService.GetDeckById(deckId);

        if (deck == null)
        {
            return NotFound();
        }

        return Ok(deck);
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> CreateDeck(DeckCreateRequest deckCreateRequest)
    {
        var deck = await _deckService.CreateDeck(deckCreateRequest);

        if (deck == null)
        {
            return BadRequest();
        }

        return Ok(deck);
    }

    [HttpPut("{deckId}")]
    public async Task<ActionResult<Deck>> UpdateDeck(int deckId, DeckUpdateRequest deckUpdateRequest)
    {
        var deck = await _deckService.UpdateDeck(deckId, deckUpdateRequest);

        if (deck == null)
        {
            return BadRequest();
        }

        return Ok(deck);
    }

    [HttpDelete("{deckId}")]
    public async Task<ActionResult<Deck>> DeleteDeck(int deckId)
    {
        var deck = await _deckService.DeleteDeck(deckId);

        if (deck == null)
        {
            return NotFound();
        }

        return Ok(deck);
    }
}
