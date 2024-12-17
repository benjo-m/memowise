using api.Data;
using api.DTO;
using api.Groq;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json.Nodes;

namespace api.Controllers;

public class CardsController : BaseController
{
    private readonly CardService _cardService;

    public CardsController(CardService cardService)
    {
        _cardService = cardService;
    }

    [HttpGet]
    public async Task<ActionResult<List<Card>>> GetCardsByDeck(int deckId)
    {
        return await _cardService.GetCardsByDeck(deckId);
    }

    [HttpPost("{deckId}")]
    public async Task<ActionResult<Card>> AddCard(int deckId, CardCreateRequest cardCreateRequest)
    {
        var card = await _cardService.AddCard(deckId, cardCreateRequest);

        if (card == null)
        {
            return BadRequest();
        }

        return Ok(card);
    }

    [HttpPut("{cardId}")]
    public async Task EditCard(int cardId, CardEditRequest cardEditRequest)
    {
        await _cardService.EditCard(cardId, cardEditRequest);
    }

    [HttpDelete("{cardId}")]
    public async Task<ActionResult<Card>> DeleteCard(int cardId)
    {
        return await _cardService.DeleteCard(cardId);
    }

    [HttpPost("generate")]
    public async Task<GenerateCardsResponse?> GenerateCards(GenerateCardsRequest generateCardsRequest)
    {
        return await _cardService.GenerateCards(generateCardsRequest);
    }

    [HttpPut]
    public async Task UpdateCardStats(List<CardStatsUpdateRequest> cardStatsUpdateRequests)
    {
        await _cardService.UpdateCardStats(cardStatsUpdateRequests);
    }
}
