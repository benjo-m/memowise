﻿using api.Data;
using api.DTO;
using api.Exceptions;
using api.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace api.Services;

public class AuthService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public AuthService(ApplicationDbContext dbContext, IHttpContextAccessor httpContextAccessor)
    {
        _dbContext = dbContext;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<UserDto?> Login(LoginRequest loginRequest)
    {
        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .Where(u => u.Username == loginRequest.Username)
            .FirstOrDefaultAsync();

        if (user == null || !BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.PasswordHashed))
        {
            return null;
        }

        await CheckStudyStreak(user);

        var userDto = new UserDto(user);

        await SaveLoginRecord(user.Id);

        return userDto;
    }

    public async Task<UserDto?> Register(RegisterRequest registerRequest)
    {
        if (registerRequest.Password != registerRequest.PasswordConfirmation)
        {
            throw new PasswordsNotMatchingException("Passwords do not match");
        }

        if (await _dbContext.Users.AnyAsync(u => u.Username == registerRequest.Username))
        {
            throw new UsernameTakenException("Username taken");
        }

        if (await _dbContext.Users.AnyAsync(u => u.Email == registerRequest.Email))
        {
            throw new EmailAlreadyInUseException("Email already in use");
        }

        var user = new User(registerRequest);

        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();

        return new UserDto(user);
    }

    public async Task<User?> GetCurrentUser()
    {
        var userId = _httpContextAccessor.HttpContext!.User
            .FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (userId == null)
        {
            return null;
        }

        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .Include(u => u.Achievements)
            .SingleOrDefaultAsync(u => u.Id == int.Parse(userId));

        return user;
    }

    private async Task CheckStudyStreak(User user)
    {
        var lastStudySession = await _dbContext.StudySessions
            .Where(ss => ss.UserId == user.Id)
            .OrderByDescending(ss => ss.StudiedAt)
            .FirstOrDefaultAsync();

        if (lastStudySession != null && lastStudySession.StudiedAt.Date < DateTime.Now.Date.AddDays(-1))
        {
            user.UserStats.StudyStreak = 0;

            _dbContext.Users.Update(user);
            await _dbContext.SaveChangesAsync();
        }
    }
    private async Task SaveLoginRecord(int userId)
    {
        var loginRecord = new LoginRecord()
        {
            UserId = userId,
            LoginDateTime = DateTime.Now
        };

        _dbContext.LoginRecords.Add(loginRecord);
        await _dbContext.SaveChangesAsync();
    }
}
