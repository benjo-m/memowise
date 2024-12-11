using api.Data;
using api.DTO;
using api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[Route("api/[controller]")]
[ApiController]
public class StudySessionsController : ControllerBase
{
    private readonly ApplicationDbContext _dbContext;

    public StudySessionsController(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    [HttpPost]
    public async Task SaveSession(StudySessionCreateRequest studySessionCreateRequest)
    {
        var studySession = new StudySession(studySessionCreateRequest);

        _dbContext.StudySessions.Add(studySession);
        await _dbContext.SaveChangesAsync();    
    }
}
