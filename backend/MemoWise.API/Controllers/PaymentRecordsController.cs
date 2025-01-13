using MemoWise.Model.DTO;
using MemoWise.Model.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class PaymentRecordsController : BaseCRUDController<PaymentRecord, PaymentRecordCreateRequest, PaymentRecordUpdateRequest>
{
    private readonly PaymentRecordService _paymentRecordService;

    public PaymentRecordsController(PaymentRecordService paymentRecordService) : base(paymentRecordService)
    {
        _paymentRecordService = paymentRecordService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllPaymentRecords
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? user = null)
    {
        var paymentRecords = await _paymentRecordService.GetAllPaymentRecords(page, pageSize, sortBy, sortDescending, user);
        return Ok(paymentRecords);
    }
}
