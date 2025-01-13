using MemoWise.Model.DTO;
using MemoWise.Model.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class CardStatsController : BaseCRUDController<CardStats, CardStatsCreateRequest, CardStatsUpdateRequestAdmin>
{
    private readonly CardStatsService _cardStatsService;

    public CardStatsController(CardStatsService cardStatsService) : base(cardStatsService)
    {
        _cardStatsService = cardStatsService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllCardStats
    (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? card = null)
    {
        var cardStats = await _cardStatsService.GetAllCardStats(page, pageSize, sortBy, sortDescending, card);
        return Ok(cardStats);
    }

    [HttpPut("bulk-update")]
    public async Task BulkUpdateCardStats(List<CardStatsUpdateRequest> cardStatsUpdateRequests)
    {
        await _cardStatsService.BulkUpdateCardStats(cardStatsUpdateRequests);
    }
}
