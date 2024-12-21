using api.DTO;
using Stripe;

namespace api.Services;

public class StripeService
{
    private readonly IConfiguration _configuration;

    public StripeService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public StripePaymentResponse UpgradeToPremium()
    {
        StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"] ?? "";

        var paymentIntentOptions = new PaymentIntentCreateOptions
        {
            Amount = 499,
            Currency = "usd",
        };

        var paymentIntentService = new PaymentIntentService();
        PaymentIntent paymentIntent = paymentIntentService.Create(paymentIntentOptions);

        return new StripePaymentResponse()
        {
            ClientSecret = paymentIntent.ClientSecret
        };
    }
}
