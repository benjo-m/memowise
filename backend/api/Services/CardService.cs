using api.Data;
using api.DTO;
using api.Exceptions;
using api.Groq;
using api.Models;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json.Nodes;

namespace api.Services;

public class CardService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IConfiguration _configuration;
    private readonly UserService _userService;
    private readonly AchievementsService _achievementService;

    public CardService(ApplicationDbContext dbContext, IConfiguration configuration, UserService userService, AchievementsService achievementService)
    {
        _dbContext = dbContext;
        _configuration = configuration;
        _userService = userService;
        _achievementService = achievementService;
    }

    public async Task<List<Card>> GetCardsByDeck(int deckId)
    {
        var cards = await _dbContext.Decks
            .Where(x => x.Id == deckId)
            .SelectMany(x => x.Cards)
            .ToListAsync();

        return cards;
    }

    public async Task<Card?> AddCard(int deckId, CardCreateRequest cardCreateRequest)
    {
        Card card = new Card(cardCreateRequest);
        var deck = await _dbContext.Decks
            .Include(d => d.Cards)
            .FirstOrDefaultAsync(x => x.Id == deckId);
        var user = await _userService.GetCurrentUser();

        if (deck == null || user == null)
        {
            return null;
        }

        if (!user.IsPremium && deck.Cards.Count == 20)
        {
            throw new NonPremiumLimitException("Card count per deck limit exceeded");
        }

        deck.Cards.Add(card);

        _dbContext.Decks.Update(deck);
        await _dbContext.SaveChangesAsync();

        user.UserStats.TotalCardsCreated++;
        _dbContext.Users.Update(user);
        await _dbContext.SaveChangesAsync();
        await _achievementService.CheckAchievements(user.Id);
        
        return card;
    }

    public async Task EditCard(int cardId, CardEditRequest cardEditRequest)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.Id == cardId)
            .FirstOrDefaultAsync();

        if (card != null)
        {
            card.Question = cardEditRequest.Question;
            card.Answer = cardEditRequest.Answer;
            card.QuestionImage = Convert.FromBase64String(cardEditRequest.QuestionImage ?? "");
            card.AnswerImage = Convert.FromBase64String(cardEditRequest.AnswerImage ?? "");

            _dbContext.Update(card);
            await _dbContext.SaveChangesAsync();
        }
    }

    public async Task<Card> DeleteCard(int cardId)
    {
        Card card = await _dbContext.Cards
            .Where(c => c.Id == cardId)
            .FirstAsync();

        _dbContext.Cards.Remove(card);
        await _dbContext.SaveChangesAsync();

        return card;
    }

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
        catch (Exception)
        {
            return new GenerateCardsResponse { Cards = new List<CardCreateRequest>() };
        }
    }

    public async Task UpdateCardStats(List<CardStatsUpdateRequest> cardStatsUpdateRequests)
    {
        foreach (var cardStats in cardStatsUpdateRequests)
        {
            Card? card = await _dbContext.Cards
                .Where(c => c.Id == cardStats.CardId)
                .Include(c => c.CardStats)
                .FirstOrDefaultAsync();

            if (card != null)
            {
                card.UpdateLearningStats(cardStats);

                _dbContext.Update(card);
                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
