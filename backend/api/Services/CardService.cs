﻿using api.Data;
using api.DTO;
using api.Groq;
using api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json.Nodes;

namespace api.Services;

public class CardService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IConfiguration _configuration;

    public CardService(ApplicationDbContext dbContext, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _configuration = configuration;
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
        var deck = await _dbContext.Decks.FirstOrDefaultAsync(x => x.Id == deckId);

        if (deck == null)
        {
            return null;
        }

        _dbContext.Add(card);
        await _dbContext.SaveChangesAsync();

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