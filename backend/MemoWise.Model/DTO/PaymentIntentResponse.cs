namespace MemoWise.Model.DTO;

public class PaymentIntentResponse
{
    public string PaymentIntentId { get; set; }
    public string ClientSecret { get; set; }
    public int UserId { get; set; }
    public long Amount { get; set; }
    public string Currency { get; set; }
    public DateTime CreatedAt { get; set; }
}
