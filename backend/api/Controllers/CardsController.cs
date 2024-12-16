using api.Data;
using api.DTO;
using api.Groq;
using api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json.Nodes;

namespace api.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class CardsController : ControllerBase
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IConfiguration _configuration;

    public CardsController(ApplicationDbContext dbContext, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _configuration = configuration;
    }

    [HttpGet]
    public async Task<ActionResult<List<Card>>> GetCardsByDeck(int deckId)
    {
        var cards = await _dbContext.Decks
            .Where(x => x.Id == deckId)
            .SelectMany(x => x.Cards)
            .ToListAsync();

        return Ok(cards);
    }

    [HttpPost("{deckId}")]
    public async Task<ActionResult<Card>> AddCard(int deckId, CardCreateRequest cardCreateRequest)
    {
        Card card = new Card(cardCreateRequest);
        card.Deck = await _dbContext.Decks.FirstAsync(x => x.Id == deckId);

        _dbContext.Add(card);
        await _dbContext.SaveChangesAsync();

        return Ok(card);
    }

    [HttpPatch("{cardId}")]
    public async Task<IActionResult> EditCard(int cardId, CardEditRequest cardEditRequest)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.Id == cardId)
            .FirstOrDefaultAsync();

        if (card == null)
        {
            return NotFound();
        }

        card.Question = cardEditRequest.Question;
        card.Answer = cardEditRequest.Answer;

        _dbContext.Update(card);
        await _dbContext.SaveChangesAsync();

        return Ok();
    }

    [HttpDelete("{cardId}")]
    public async Task<ActionResult<Card>> DeleteCard(int cardId)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.Id == cardId)
            .FirstOrDefaultAsync();

        if (card == null)
        {
            return NotFound();
        }

        _dbContext.Cards.Remove(card);
        await _dbContext.SaveChangesAsync();

        return Ok(card);
    }

    [HttpPost("generate")]
    public async Task<GenerateCardsResponse?> GenerateCards(GenerateCardsRequest generateCardsRequest)
    {
        var groqApi = new GroqApiClient(_configuration["Groq:ApiKey"]!);

        var request = new JsonObject
        {
            ["model"] = _configuration["Groq:Model"],
            ["messages"] = new JsonArray
            {
                new JsonObject
                {
                    ["role"] = "user",
                    ["content"] = _configuration["Groq:Prompt"]!
                        .Replace("{input_phrase}", generateCardsRequest.Topic)
                        .Replace("{num_cards}", generateCardsRequest.CardCount.ToString())
                }
            }
        };

        var result = await groqApi.CreateChatCompletionAsync(request);
        var response = result?["choices"]?[0]?["message"]?["content"]?.ToString();

        try
        {
            var generatedCards = JsonConvert.DeserializeObject<GenerateCardsResponse>(response!);
            return generatedCards;
        }
        catch (Exception e)
        {
            return new GenerateCardsResponse { Cards = new List<CardCreateRequest>() };
        }
    }

    [HttpPatch]
    public async Task<IActionResult> UpdateCardStats(List<CardStatsUpdateRequest> cardStatsUpdateRequests)
    {
        foreach (var cardStats in cardStatsUpdateRequests)
        {
            Card? card = await _dbContext.Cards
                .Where(c => c.Id == cardStats.CardId)
                .Include(c => c.CardStats)
                .FirstOrDefaultAsync();

            if (card == null)
            {
                return NotFound();
            }

            card.UpdateLearningStats(cardStats);

            _dbContext.Update(card);
            await _dbContext.SaveChangesAsync();
        }


        return Ok();
    }
}
