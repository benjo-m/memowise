using MemoWise.Model.DTO;
using MemoWise.Model.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class CardsController : BaseCRUDController<Card, CardCreateRequest, CardUpdateRequest>
{
    private readonly CardService _cardService;

    public CardsController(CardService cardService) : base(cardService)
    {
        _cardService = cardService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllCards
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? deck = null)
    {
        var cards = await _cardService.GetAllCards(page, pageSize, sortBy, sortDescending, deck);
        return Ok(cards);
    }

    [HttpGet("deck/{deckId}")]
    public async Task<ActionResult<List<Card>>> GetCardsByDeck(int deckId)
    {
        return await _cardService.GetCardsByDeck(deckId);
    }

    [HttpPost("{deckId}")]
    public async Task<ActionResult<Card>> AddCard(int deckId, CardAddRequest cardCreateRequest)
    {

        var card = await _cardService.AddCard(deckId, cardCreateRequest);

        if (card == null)
        {
            return BadRequest();
        }

        return Ok(card);
    }

    [HttpPut("edit/{cardId}")]
    public async Task EditCard(int cardId, CardEditRequest cardEditRequest)
    {
        await _cardService.EditCard(cardId, cardEditRequest);
    }

    [HttpPost("generate")]
    public async Task<GenerateCardsResponse?> GenerateCards(GenerateCardsRequest generateCardsRequest)
    {
        return await _cardService.GenerateCards(generateCardsRequest);
    }
}
