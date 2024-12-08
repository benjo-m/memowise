using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Data;
using api.Models;
using api.DTO;
using Microsoft.AspNetCore.Authorization;
using api.Services;
using System.Text.Json.Nodes;
using api.Groq;
using Newtonsoft.Json;

namespace api.Controllers;

[Authorize]
[Route("[controller]")]
[ApiController]
public class DecksController : ControllerBase
{
    private readonly ApplicationDbContext _dbContext;
    private readonly UserService _userService;
    private readonly IConfiguration _configuration;

    public DecksController(ApplicationDbContext dbContext, UserService userService, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _userService = userService;
        _configuration = configuration;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Deck>> GetDeckById(int id)
    {
        var deck = await _dbContext.Decks
            .Include(d => d.Cards)
            .FirstOrDefaultAsync(d => d.Id == id);

        if (deck == null)
        {
            return NotFound();
        }

        return deck;
    }

    [HttpPost]
    public async Task<ActionResult<Deck>> CreateDeck(DeckCreateRequest deckCreateRequest)
    {
        User? user = await _userService.GetCurrentUser(Request.Headers.Authorization);

        if (user == null)
        {
            return NotFound();
        }

        Deck deck = new Deck(deckCreateRequest);
        deck.User = user;

        _dbContext.Decks.Add(deck);
        await _dbContext.SaveChangesAsync();

        return deck;
    }

    [HttpPatch("{id}")]
    public async Task<IActionResult> UpdateDeck(int id, DeckUpdateRequest deckUpdateRequest)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(id);

        if (deck == null)
        {
            return NotFound();
        }

        deck.Name = deckUpdateRequest.Name;

        _dbContext.Decks.Update(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    [HttpDelete("{deckId}")]
    public async Task<IActionResult> DeleteDeck(int deckId)
    {
        Deck? deck = await _dbContext.Decks.FindAsync(deckId);
        User? user = await _userService.GetCurrentUser(Request.Headers.Authorization);

        if (deck == null)
        {
            return NotFound();
        }
        else if (user == null || user.Id != deck.UserId)
        {
            return Forbid();
        }

        _dbContext.Decks.Remove(deck);
        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    [HttpGet("user/{firebaseUid}")]
    public async Task<ActionResult<List<DeckSummary>>> GetDecksByUser(string firebaseUid)
    {
        return await _dbContext.Decks
            .Where(x => x.User.FirebaseUid == firebaseUid)
            .Include(x => x.Cards)
            .Select(deck => new DeckSummary(deck))
            .ToListAsync();
    }

    [HttpGet("{deckId}/cards")]
    public async Task<ActionResult<List<Card>>> GetCardsByDeck(int deckId)
    {
        var cards = await _dbContext.Decks
            .Where(x => x.Id == deckId)
            .SelectMany(x => x.Cards)
            .ToListAsync();

        return Ok(cards);
    }

    [HttpPost("{deckId}/cards")]
    public async Task<ActionResult<Card>> AddCard(int deckId, CardDto cardDto) 
    {
        Card card = new Card(cardDto);
        card.Deck = await _dbContext.Decks.FirstAsync(x => x.Id == deckId);

        _dbContext.Add(card);
        await _dbContext.SaveChangesAsync();

        return Ok(card);
    }

    [HttpPatch("{deckId}/cards/{cardId}")]
    public async Task<IActionResult> EditCard(int deckId, int cardId, CardDto cardDto)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.DeckId == deckId && c.Id == cardId)
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

    [HttpDelete("{deckId}/cards/{cardId}")]
    public async Task<ActionResult<Card>> DeleteCard(int deckId, int cardId)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.DeckId == deckId && c.Id == cardId)
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
}
