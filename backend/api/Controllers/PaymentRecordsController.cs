using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;


[AllowAnonymous]
public class PaymentRecordsController : BaseController
{
    private readonly PaymentRecordService _paymentRecordService;

    public PaymentRecordsController(PaymentRecordService paymentRecordService)
    {
        _paymentRecordService = paymentRecordService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllPaymentRecords
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? user = null)
    {
        var paymentRecords = await _paymentRecordService.GetAllPaymentRecords(page, pageSize, sortBy, sortDescending, user);
        return Ok(paymentRecords);
    }

    [HttpPost]
    public async Task<IActionResult> SavePaymentRecord(PaymentRecordCreateRequest paymentRecordCreateRequest)
    {
        await _paymentRecordService.SavePaymentRecord(paymentRecordCreateRequest);
        return Ok();
    }
}
