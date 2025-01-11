using api.DTO;
using api.Models;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class StudySessionsController : BaseCRUDController<StudySession, StudySessionCreateRequest, StudySessionUpdateRequest>
{
    private readonly StudySessionService _studySessionService;

    public StudySessionsController(StudySessionService studySessionService, SeedDataService seedDataService) : base(studySessionService)
    {
        _studySessionService = studySessionService;
    }

    [Authorize(Roles = "SuperAdmin")]
    [HttpGet]
    public async Task<IActionResult> GetAllStudySessions
    (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? deck = null, int? user = null)
    {
        var studySessions = await _studySessionService.GetAllStudySessions(page, pageSize, sortBy, sortDescending, deck, user);
        return Ok(studySessions);
    }

    [HttpPost("complete")]
    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        await _studySessionService.CompleteStudySession(studySessionCreateRequest);
    }
}
