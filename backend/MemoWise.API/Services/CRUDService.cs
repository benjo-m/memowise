using api.Data;
using api.Exceptions;
using MemoWise.Model.Models;
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

        await CheckExceptions(entity);

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

        await CheckExceptions(entity);

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

    private async Task CheckExceptions<TEntity>(TEntity entity) where TEntity : class
    {
        if (typeof(TEntity) == typeof(User))
        {
            var request = entity as User;

            if (await _dbContext.Users.AnyAsync(u => u.Username == request!.Username && u.Id != request.Id))
            {
                throw new DuplicateEntryException("USERNAME_TAKEN", "User already exists");
            }

            if (await _dbContext.Users.AnyAsync(u => u.Email == request!.Email && u.Id != request.Id))
            {
                throw new DuplicateEntryException("EMAIL_TAKEN", "Email already in use");
            }
        }

        if (typeof (TEntity) == typeof(Achievement))
        {
            var request = entity as Achievement;

            if (await _dbContext.Achievements.AnyAsync(a => a.Name == request!.Name && a.Id != request.Id))
            {
                throw new DuplicateEntryException("ACHIEVEMENT_NAME_TAKEN", "Achievement with this name already exists");
            }
        }

        if (typeof(TEntity) == typeof(CardStats))
        {
            var request = entity as CardStats;

            if (await _dbContext.CardStats.AnyAsync(cs => cs.CardId == request!.CardId))
            {
                throw new DuplicateEntryException("CARD_ID_TAKEN", "Card Stats already exists for this card");
            }

            if (!await _dbContext.Cards.AnyAsync(c => c.Id == request!.CardId))
            {
                throw new InvalidIdException("CARD_DOES_NOT_EXIST", "Card does not exist");
            }
        }

        if (typeof(TEntity) == typeof(UserStats))
        {
            var request = entity as UserStats;

            if (await _dbContext.UserStats.AnyAsync(us => us.UserId == request!.UserId))
            {
                throw new DuplicateEntryException("USER_ID_TAKEN", "User Stats already exists for this user");
            }

            if (!await _dbContext.Users.AnyAsync(u => u.Id == request!.UserId))
            {
                throw new InvalidIdException("USER_DOES_NOT_EXIST", "User does not exist");
            }
        }

        if (typeof(TEntity) == typeof(StudySession))
        {
            var request = entity as StudySession;

            if (!await _dbContext.Users.AnyAsync(u => u.Id == request!.UserId))
            {
                throw new InvalidIdException("USER_DOES_NOT_EXIST", "User does not exist");
            }

            if (!await _dbContext.Decks.AnyAsync(d => d.Id == request!.DeckId))
            {
                throw new InvalidIdException("DECK_DOES_NOT_EXIST", "Deck does not exist");
            }
        }

        if (typeof(TEntity) == typeof(Card))
        {
            var request = entity as Card;

            if (!await _dbContext.Decks.AnyAsync(d => d.Id == request!.DeckId))
            {
                throw new InvalidIdException("DECK_DOES_NOT_EXIST", "Deck does not exist");
            }
        }

        if (typeof(TEntity) == typeof(Feedback))
        {
            var request = entity as Feedback;

            if (!await _dbContext.Users.AnyAsync(u => u.Id == request!.UserId))
            {
                throw new InvalidIdException("USER_DOES_NOT_EXIST", "User does not exist");
            }
        }

        if (typeof(TEntity) == typeof(Deck))
        {
            var request = entity as Deck;

            if (!await _dbContext.Users.AnyAsync(u => u.Id == request!.UserId))
            {
                throw new InvalidIdException("USER_DOES_NOT_EXIST", "User does not exist");
            }
        }

        if (typeof(TEntity) == typeof(LoginRecord))
        {
            var request = entity as LoginRecord;

            if (!await _dbContext.Users.AnyAsync(u => u.Id == request!.UserId))
            {
                throw new InvalidIdException("USER_DOES_NOT_EXIST", "User does not exist");
            }
        }

        if (typeof(TEntity) == typeof(PaymentRecord))
        {
            var request = entity as PaymentRecord;

            if (!await _dbContext.Users.AnyAsync(u => u.Id == request!.UserId))
            {
                throw new InvalidIdException("USER_DOES_NOT_EXIST", "User does not exist");
            }
        }
    }
}
