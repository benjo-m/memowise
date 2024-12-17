﻿using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class StudySessionsController : BaseController
{
    private readonly StudySessionService _studySessionService;

    public StudySessionsController(StudySessionService studySessionService)
    {
        _studySessionService = studySessionService;
    }

    [HttpPost]
    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        await _studySessionService.SaveSession(studySessionCreateRequest);
    }

    [HttpGet("generate-500")]
    public void GenerarateStudySessions()
    {
        _studySessionService.GenerateMockStudySessions();
    }
}
