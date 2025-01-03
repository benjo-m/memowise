﻿using api.Models;

namespace api.DTO;

public class UserDto
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public bool IsPremium { get; set; }
    public bool IsAdmin { get; set; }

    public UserDto(User user)
    {
        Id = user.Id;
        Username = user.Username;
        Email = user.Email;
        IsPremium = user.IsPremium;
        IsAdmin = user.IsAdmin;
    }
}
