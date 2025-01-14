﻿using MemoWise.Model.DTO;
using MemoWise.Model.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class LoginRecordsController : BaseCRUDController<LoginRecord, LoginRecordCreateRequest, LoginRecordUpdateRequest>
{
    private readonly LoginRecordService _loginRecordService;
    public LoginRecordsController(LoginRecordService loginRecordService) : base(loginRecordService)
    {
        _loginRecordService = loginRecordService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllLoginRecords
        (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? user = null)
    {
        var loginRecords = await _loginRecordService.GetAllLoginRecords(page, pageSize, sortBy, sortDescending, user);
        return Ok(loginRecords);
    }
}
