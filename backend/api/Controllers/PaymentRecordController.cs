using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class PaymentRecordController : BaseController
{
    private readonly PaymentRecordService _paymentRecordService;

    public PaymentRecordController(PaymentRecordService paymentRecordService)
    {
        _paymentRecordService = paymentRecordService;
    }

    [HttpPost]
    public async Task<IActionResult> SavePaymentRecord(PaymentRecordCreateRequest paymentRecordCreateRequest)
    {
        await _paymentRecordService.SavePaymentRecord(paymentRecordCreateRequest);
        return Ok();
    }
}
