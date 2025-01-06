using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[AllowAnonymous]
public class LoginRecordsController : BaseCRUDController<LoginRecord, LoginRecordCreateRequest, LoginRecordUpdateRequest>
{
    private readonly LoginRecordService _loginRecordService;
    public LoginRecordsController(LoginRecordService loginRecordService) : base(loginRecordService)
    {
        _loginRecordService = loginRecordService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllLoginRecords
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? user = null)
    {
        var loginRecords = await _loginRecordService.GetAllLoginRecords(page, pageSize, sortBy, sortDescending, user);
        return Ok(loginRecords);
    }
}
