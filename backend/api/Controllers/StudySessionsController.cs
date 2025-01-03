using api.DTO;
using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

public class StudySessionsController : BaseController
{
    private readonly StudySessionService _studySessionService;

    public StudySessionsController(StudySessionService studySessionService, SeedDataService seedDataService)
    {
        _studySessionService = studySessionService;
    }

    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> GetAllDecks
    (int page = 1, int pageSize = 10, string? sortBy = "id", bool sortDescending = false, int? deck = null, int? user = null)
    {
        var studySessions = await _studySessionService.GetAllStudySessions(page, pageSize, sortBy, sortDescending, deck, user);
        return Ok(studySessions);
    }

    [HttpPost]
    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        await _studySessionService.SaveSession(studySessionCreateRequest);
    }
}
