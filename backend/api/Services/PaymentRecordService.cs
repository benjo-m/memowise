using api.Data;
using api.DTO;
using api.Models;

namespace api.Services;

public class PaymentRecordService
{
    private readonly ApplicationDbContext _dbContext;
    public PaymentRecordService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task SavePaymentRecord(PaymentRecordCreateRequest paymentRecordCreateRequest)
    {
        var paymentRecord = new PaymentRecord(paymentRecordCreateRequest);

        _dbContext.PaymentRecords.Add(paymentRecord);
        await _dbContext.SaveChangesAsync();
    }
}
