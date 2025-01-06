using Microsoft.AspNetCore.Mvc;
using api.Models;
using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;

namespace api.Controllers;

public class DecksController : BaseCRUDController<Deck, DeckCreateRequest, DeckUpdateRequest>
{
    private readonly DeckService _deckService;

    public DecksController(DeckService deckService) : base(deckService)
    {
        _deckService = deckService;
    }

    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> GetAllDecks
    (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? user = null)
    {
        var decks = await _deckService.GetAllDecks(page, pageSize, sortBy, sortDescending, user);
        return Ok(decks);
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<List<DeckSummary>>> GetDecksByUser(int userId)
    {
        var decks = await _deckService.GetDecksByUser(userId);
        return Ok(decks);
    }

    [HttpGet("{deckId}/cards")]
    public async Task<ActionResult<Deck>> GetDeckWithCards(int deckId)
    {
        var deck = await _deckService.GetDeckWithCards(deckId);

        if (deck == null)
        {
            return NotFound();
        }

        return Ok(deck);
    }

    [HttpPost("with-cards")]
    public async Task<ActionResult<Deck>> CreateDeckWithCards(DeckCreateRequestWithCards deckCreateRequest)
    {
        var deck = await _deckService.CreateDeckWithCards(deckCreateRequest);

        if (deck == null)
        {
            return BadRequest();
        }

        return Ok(deck);
    }

    //[HttpPut("{deckId}")]
    //public async Task<ActionResult<Deck>> UpdateDeck(int deckId, DeckUpdateRequest deckUpdateRequest)
    //{
    //    var deck = await _deckService.UpdateDeck(deckId, deckUpdateRequest);

    //    if (deck == null)
    //    {
    //        return BadRequest();
    //    }

    //    return Ok(deck);
    //}

    //[HttpDelete("{deckId}")]
    //public async Task<ActionResult<Deck>> DeleteDeck(int deckId)
    //{
    //    var deck = await _deckService.DeleteDeck(deckId);

    //    if (deck == null)
    //    {
    //        return NotFound();
    //    }

    //    return Ok(deck);
    //}
}
