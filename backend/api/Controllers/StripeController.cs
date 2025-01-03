using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class StripeController : BaseController
{
    private readonly StripeService _stripeService;

    public StripeController(StripeService stripeService)
    {
        _stripeService = stripeService;
    }

    [HttpPost("payment-intent/{userId}")]
    public ActionResult<PaymentIntentResponse> CreatePaymentIntent(int userId)
    {
        return _stripeService.CreatePaymentIntent(userId);
    }
}
