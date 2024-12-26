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

    public PaymentRecord(PaymentRecordCreateRequest paymentRecordCreateRequest)
    {
        PaymentIntentId = paymentRecordCreateRequest.PaymentIntentId;
        UserId = paymentRecordCreateRequest.UserId;
        Amount = paymentRecordCreateRequest.Amount;
        Currency = paymentRecordCreateRequest.Currency;
        CreatedAt = paymentRecordCreateRequest.CreatedAt;
    }
}
