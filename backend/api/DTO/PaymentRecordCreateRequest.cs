namespace api.DTO;

public class PaymentRecordCreateRequest
{
    public string PaymentIntentId { get; set; }
    public int UserId { get; set; }
    public long Amount { get; set; }
    public string Currency { get; set; }
    public DateTime CreatedAt { get; set; }
}
