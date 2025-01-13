using api.Data;
using MemoWise.Model.DTO;
using Stripe;

namespace api.Services;

public class StripeService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IConfiguration _configuration;

    public StripeService(IConfiguration configuration, ApplicationDbContext dbContext)
    {
        _configuration = configuration;
        _dbContext = dbContext;
    }

    public PaymentIntentResponse CreatePaymentIntent(int userId)
    {
        StripeConfiguration.ApiKey = _configuration["STRIPE_SK"] ?? "";

        var paymentIntentOptions = new PaymentIntentCreateOptions
        {
            Amount = 499,
            Currency = "usd",
        };

        var paymentIntentService = new PaymentIntentService();
        PaymentIntent paymentIntent = paymentIntentService.Create(paymentIntentOptions);

        return new PaymentIntentResponse()
        {
            PaymentIntentId = paymentIntent.Id,
            ClientSecret = paymentIntent.ClientSecret,
            UserId = userId,
            Amount = paymentIntent.Amount,
            Currency = paymentIntent.Currency,
            CreatedAt = DateTime.Now,
        };
    }


}
