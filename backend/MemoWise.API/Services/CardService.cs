using api.Data;
using MemoWise.Model.DTO;
using api.Exceptions;
using api.Groq;
using MemoWise.Model.Models;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json.Nodes;

namespace api.Services;

public class CardService : CRUDService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IConfiguration _configuration;
    private readonly AuthService _authService;
    private readonly AchievementsService _achievementService;

    public CardService(ApplicationDbContext dbContext, IConfiguration configuration, AchievementsService achievementService, AuthService authService) : base(dbContext)
    {
        _dbContext = dbContext;
        _configuration = configuration;
        _achievementService = achievementService;
        _authService = authService;
    }

    public async Task<PaginatedResponse<CardDto>> GetAllCards
        (int page, int pageSize, string? sortBy, bool sortDescending, int? deck)
    {
        var query = _dbContext.Cards
            .Select(card => new CardDto
            {
                Id = card.Id,
                Question = card.Question, 
                Answer = card.Answer,
                DeckId = card.DeckId
            });

        if (deck != null)
        {
            query = query.Where(c => c.DeckId == deck);
        }

        query = sortBy switch
        {
            "question" => sortDescending ? query.OrderByDescending(c => c.Question) : query.OrderBy(c => c.Question),
            "answer" => sortDescending ? query.OrderByDescending(c => c.Answer) : query.OrderBy(c => c.Answer),
            "deck" => sortDescending ? query.OrderByDescending(c => c.DeckId) : query.OrderBy(c => c.DeckId),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var cards = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<CardDto>(cards, page, totalPages);
    }

    public async Task<List<Card>> GetCardsByDeck(int deckId)
    {
        var cards = await _dbContext.Decks
            .Where(x => x.Id == deckId)
            .SelectMany(x => x.Cards)
            .ToListAsync();

        return cards;
    }

    public async Task<Card?> AddCard(int deckId, CardAddRequest cardCreateRequest)
    {
        Card card = new Card(cardCreateRequest);
        var deck = await _dbContext.Decks
            .Include(d => d.Cards)
            .FirstOrDefaultAsync(x => x.Id == deckId);
        var user = await _authService.GetCurrentUser();

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

    public async Task UpdateLearningStats(CardStatsUpdateRequest request)
    {
        Card? card = await _dbContext.Cards
            .Where(c => c.Id == request.CardId)
            .Include(c => c.CardStats)
            .FirstOrDefaultAsync();

        if (card != null)
        {
            card.UpdateLearningStats(request);

            _dbContext.Update(card);
            await _dbContext.SaveChangesAsync();
        }
    }

    public async Task<GenerateCardsResponse?> GenerateCards(GenerateCardsRequest generateCardsRequest)
    {
        var user = await _authService.GetCurrentUser();

        var groqApi = new GroqApiClient(_configuration["GROQ_API_KEY"]!);

        var request = new JsonObject
        {
            ["model"] = _configuration["GROQ_MODEL"],
            ["messages"] = new JsonArray
            {
                new JsonObject
                {
                    ["role"] = "user",
                    ["content"] = "Is the phrase \"{input_phrase}\" a valid and meaningful phrase in English? If it is valid, please generate {num_cards} flashcards based on this phrase. The flashcards should be in the following JSON format: {\"cards\": [{\"question\": \"Your question here\", \"answer\": \"Your answer here\"}]} The response should only contain the JSON object, with no additional text, DO NOT ADD ```json ``` AROUND IT!!!. If the phrase is not valid, return an empty array."
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
            user.UserStats.TotalDecksGenerated++;
            _dbContext.Users.Update(user);
            await _dbContext.SaveChangesAsync();
            return generatedCards;
        }
        catch (Exception)
        {
            return new GenerateCardsResponse { Cards = new List<CardAddRequest>() };
        }
    }
}
