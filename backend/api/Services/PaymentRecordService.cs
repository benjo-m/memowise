using api.Data;
using api.DTO;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class PaymentRecordService
{
    private readonly ApplicationDbContext _dbContext;
    public PaymentRecordService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PaginatedResponse<PaymentRecord>> GetAllPaymentRecords
    (int page, int pageSize, string? sortBy, bool sortDescending, int? user)
    {
        var query = _dbContext.PaymentRecords.AsQueryable();

        if (user != null)
        {
            query = query.Where(pr => pr.UserId == user);
        }

        query = sortBy switch
        {
            "user" => sortDescending ? query.OrderByDescending(pr => pr.UserId) : query.OrderBy(pr => pr.UserId),
            "paymentIntent" => sortDescending ? query.OrderByDescending(pr => pr.PaymentIntentId) : query.OrderBy(pr => pr.PaymentIntentId),
            "amount" => sortDescending ? query.OrderByDescending(pr => pr.Amount) : query.OrderBy(pr => pr.Amount),
            "currency" => sortDescending ? query.OrderByDescending(pr => pr.Currency) : query.OrderBy(pr => pr.Currency),
            "date" => sortDescending ? query.OrderByDescending(pr => pr.CreatedAt) : query.OrderBy(pr => pr.CreatedAt),
            _ => sortDescending ? query.OrderByDescending(pr => pr.Id) : query.OrderBy(pr => pr.Id)
        };
        var paymentRecords = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
        var count = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(count / (double)pageSize);
        return new PaginatedResponse<PaymentRecord>(paymentRecords, page, totalPages);
    }

    public async Task SavePaymentRecord(PaymentRecordCreateRequest paymentRecordCreateRequest)
    {
        var paymentRecord = new PaymentRecord(paymentRecordCreateRequest);

        _dbContext.PaymentRecords.Add(paymentRecord);
        await _dbContext.SaveChangesAsync();
    }
}
