using api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[Authorize]
[Route("[controller]")]
[ApiController]
public abstract class BaseControllerTest<TEntity, TCreateRequest, TUpdateRequest> : ControllerBase where TEntity : class where TCreateRequest : class where TUpdateRequest : class
{
    private readonly CRUDService _crudService;

    public BaseControllerTest(CRUDService crudService)
    {
        _crudService = crudService;
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var entity = await _crudService.GetById<TEntity>(id);
        if (entity == null)
        {
            return NotFound();
        }
        return Ok(entity);
    }

    [HttpPost]
    public async Task<IActionResult> Create(TCreateRequest request)
    {
        var entity = await _crudService.Create<TEntity, TCreateRequest>(request);
        return Ok(entity);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, TUpdateRequest request)
    {
        var entity = await _crudService.Update<TEntity, TUpdateRequest>(id, request);
        if (entity == null)
        {
            return NotFound();
        }
        return Ok(entity);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var entity = await _crudService.Delete<TEntity>(id);
        if (entity == null)
            return NotFound();
        return Ok(entity);
    }
}
