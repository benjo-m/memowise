﻿namespace MemoWise.Model.DTO;

public class UserUpdateRequest
{
    public string Username { get; set; }
    public string Email { get; set; }
    public bool IsPremium { get; set; }
    public bool IsAdmin { get; set; }
    public DateTime CreatedAt { get; set; }
}
