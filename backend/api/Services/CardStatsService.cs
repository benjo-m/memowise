﻿using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class CardStatsService
{
    private readonly ApplicationDbContext _dbContext;

    public CardStatsService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedResponse<CardStats>> GetAllCardStats
        (int page, int pageSize, string? sortBy, bool sortDescending, int? card)
    {
        var query = _dbContext.CardStats.AsQueryable();

        if (card != null)
        {
            query = query.Where(c => c.CardId == card);
        }

        query = sortBy switch
        {
            "repetitions" => sortDescending ? query.OrderByDescending(c => c.Repetitions) : query.OrderBy(c => c.Repetitions),
            "interval" => sortDescending ? query.OrderByDescending(c => c.Interval) : query.OrderBy(c => c.Interval),
            "easeFactor" => sortDescending ? query.OrderByDescending(c => c.EaseFactor) : query.OrderBy(c => c.EaseFactor),
            "dueDate" => sortDescending ? query.OrderByDescending(c => c.DueDate) : query.OrderBy(c => c.DueDate),
            "card" => sortDescending ? query.OrderByDescending(c => c.CardId) : query.OrderBy(c => c.CardId),
            _ => sortDescending ? query.OrderByDescending(f => f.Id) : query.OrderBy(f => f.Id)
        };

        var cardStats = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);

        return new PaginatedResponse<CardStats>(cardStats, page, totalPages);
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