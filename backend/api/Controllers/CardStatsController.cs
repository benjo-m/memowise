using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class CardStatsController : BaseController
{
    private readonly CardStatsService _cardStatsService;

    public CardStatsController(CardStatsService cardStatsService)
    {
        _cardStatsService = cardStatsService;
    }

    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> GetAllDecks
    (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? card = null)
    {
        var cardStats = await _cardStatsService.GetAllCardStats(page, pageSize, sortBy, sortDescending, card);
        return Ok(cardStats);
    }

    [HttpPut]
    public async Task UpdateCardStats(List<CardStatsUpdateRequest> cardStatsUpdateRequests)
    {
        await _cardStatsService.UpdateCardStats(cardStatsUpdateRequests);
    }
}
