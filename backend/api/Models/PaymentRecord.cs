using api.DTO;

namespace api.Models;

public class PaymentRecord
{
    public int Id { get; set; }
    public string PaymentIntentId { get; set; }
    public int UserId { get; set; }
    public long Amount { get; set; }
    public string Currency { get; set; }
    public DateTime CreatedAt { get; set; }

    public PaymentRecord()
    {
    }

    public PaymentRecord(PaymentRecordCreateRequest request)
    {
        PaymentIntentId = request.PaymentIntentId;
        UserId = request.UserId;
        Amount = request.Amount;
        Currency = request.Currency;
        CreatedAt = request.CreatedAt;
    }

    public PaymentRecord Update(PaymentRecordUpdateRequest request)
    {
        PaymentIntentId = request.PaymentIntentId;
        UserId = request.UserId;
        Amount = request.Amount;
        Currency = request.Currency;
        CreatedAt = request.CreatedAt;
        return this;
    }
}
