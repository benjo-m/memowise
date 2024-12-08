using api.Data;
using api.DTO;
using api.Groq;
using api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json.Nodes;

namespace api.Controllers;

[Route("api/[controller]")]
[ApiController]
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

    [HttpPost]
    public async Task<ActionResult<Card>> AddCard(int deckId, CardDto cardDto)
    {
        Card card = new Card(cardDto);
        card.Deck = await _dbContext.Decks.FirstAsync(x => x.Id == deckId);

        _dbContext.Add(card);
        await _dbContext.SaveChangesAsync();

        return Ok(card);
    }

    [HttpPatch("{cardId}")]
    public async Task<IActionResult> EditCard(int cardId, CardDto cardDto)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.Id == cardId)
            .FirstOrDefaultAsync();

        if (card == null)
        {
            return NotFound();
        }

        card.Question = cardDto.Question;
        card.Answer = cardDto.Answer;

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
                    ["content"] = string.Format(_configuration["Groq:Prompt"]!, generateCardsRequest.CardCount, generateCardsRequest.Topic)
                }
            }
        };

        var result = await groqApi.CreateChatCompletionAsync(request);
        var response = result?["choices"]?[0]?["message"]?["content"]?.ToString();
        var generatedCards = JsonConvert.DeserializeObject<GenerateCardsResponse>(response!);

        return generatedCards;
    }

    [HttpPatch("{deckId}/cards-learning-stats/{cardId}")]
    public async Task<IActionResult> UpdateCardLearningStats(CardLearningStatsUpdateRequest cardLearningStatsUpdateRequest)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.Id == cardLearningStatsUpdateRequest.Id)
            .FirstOrDefaultAsync();

        if (card == null)
        {
            return NotFound();
        }

        card.UpdateLearningStats(cardLearningStatsUpdateRequest);

        _dbContext.Update(card);
        await _dbContext.SaveChangesAsync();

        return Ok();
    }

}
