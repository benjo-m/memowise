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

    [HttpPost("predict")]
    public StudySessionDurationPrediction PredictStudySessionDuration(StudySessionDurationInput studySessionDurationInput)
    {
        return _studySessionService.PredictStudySessionDuration(studySessionDurationInput);
    }
}
