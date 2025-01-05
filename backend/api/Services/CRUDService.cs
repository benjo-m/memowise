using api.Data;

namespace api.Services;

public class CRUDService
{
    private readonly ApplicationDbContext _dbContext;

    public CRUDService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<TEntity?> GetById<TEntity>(int id) where TEntity : class
    {
        return await _dbContext.Set<TEntity>().FindAsync(id);
    }

    public async Task<TEntity> Create<TEntity, TCreateRequest>(TCreateRequest req) where TEntity : class where TCreateRequest : class
    {
        var constructor = typeof(TEntity).GetConstructor(new[] { typeof(TCreateRequest) });

        TEntity entity = (TEntity)constructor!.Invoke(new object[] { req });

        await _dbContext.Set<TEntity>().AddAsync(entity);
        await _dbContext.SaveChangesAsync();

        return entity;
    }

    public async Task<TEntity?> Update<TEntity, TUpdateRequest>(int id, TUpdateRequest req) where TEntity : class where TUpdateRequest : class
    {
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);

        if (entity == null)
        {
            return null;
        }

        var updateMethod = typeof(TEntity).GetMethod("Update");
        
        updateMethod!.Invoke(entity, new object[] { req });

        await _dbContext.SaveChangesAsync();

        return entity;
    }


    public async Task<TEntity?> Delete<TEntity>(int id) where TEntity : class
    {
        TEntity? entity = await GetById<TEntity>(id);

        if (entity == null)
        {
            return null;
        }

        _dbContext.Set<TEntity>().Remove(entity);

        await _dbContext.SaveChangesAsync();

        return entity;
    }

}
