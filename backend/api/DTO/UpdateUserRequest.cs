﻿namespace api.DTO;

public class UpdateUserRequest
{
    public string Username { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
}