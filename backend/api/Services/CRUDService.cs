using api.Data;
using api.Exceptions;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

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

        try
        {
            await _dbContext.Set<TEntity>().AddAsync(entity);
            await _dbContext.SaveChangesAsync();
        }
        catch (DbUpdateException ex)
        {
            if (ex.InnerException is SqlException sqlEx && sqlEx.Number == 2601)
            {
                if (sqlEx.Message.Contains("IX_Users_Username"))
                {
                    throw new DuplicateEntryException("USERNAME_TAKEN", "A user with the same name already exists.");
                }
                if (sqlEx.Message.Contains("IX_Users_Email"))
                {
                    throw new DuplicateEntryException("EMAIL_TAKEN", "A user with the same email already exists.");
                }
                if (sqlEx.Message.Contains("IX_CardStats_CardId"))
                {
                    throw new DuplicateEntryException("CARD_ID_TAKEN", "A card stats for this card already exists.");
                }
                throw new DuplicateEntryException("ACHIEVEMENT_NAME_TAKEN", "An achievement with the same name already exists.");
            }
        } 
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        } 

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

        try
        {
            await _dbContext.SaveChangesAsync();
        }
        catch (DbUpdateException ex)
        {
            if (ex.InnerException is SqlException sqlEx && sqlEx.Number == 2601)
            {
                if (sqlEx.Message.Contains("IX_Users_Username"))
                {
                    throw new DuplicateEntryException("USERNAME_TAKEN", "A user with the same name already exists.");
                }
                if (sqlEx.Message.Contains("IX_Users_Email"))
                {
                    throw new DuplicateEntryException("EMAIL_TAKEN", "A user with the same email already exists.");
                }

                throw new DuplicateEntryException("ACHIEVEMENT_NAME_TAKEN", "An achievement with the same name already exists.");
            }
        }

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
