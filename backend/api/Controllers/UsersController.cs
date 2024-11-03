using api.Data;
using api.DTO;
using api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[Route("[controller]")]
[ApiController]
public class UsersController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public UsersController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost]
    public async Task<IActionResult> PostUser(UserCreateRequest request)
    {
        User user = new User(request);

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Created();
    }
}
