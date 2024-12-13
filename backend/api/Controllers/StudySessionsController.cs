using api.Data;
using api.DTO;
using api.ML;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[Route("api/[controller]")]
[ApiController]
public class StudySessionsController : ControllerBase
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
