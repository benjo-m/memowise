using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[Authorize]
[Route("[controller]")]
[ApiController]
public abstract class BaseController : ControllerBase
{
}
