using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class PaymentRecordController : BaseController
{
    private readonly StripeService _stripeService;

    public PaymentRecordController(StripeService stripeService)
    {
        _stripeService = stripeService;
    }

    [HttpPost]
    public async Task<IActionResult> SavePaymentRecord(PaymentRecordCreateRequest paymentRecordCreateRequest)
    {
        await _stripeService.SavePaymentRecord(paymentRecordCreateRequest);
        return Ok();
    }
}
