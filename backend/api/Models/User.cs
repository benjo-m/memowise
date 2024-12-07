﻿using api.DTO;

namespace api.Models;

public class User
{
    public int Id { get; set; }
    public string Email { get; set; }
    public string FirebaseUid { get; set; }
    public ICollection<Deck> Decks { get; set; } = new List<Deck>();

    public User() {}

    public User(UserSaveRequest userSaveRequest)
    {
        Email = userSaveRequest.Email;
        FirebaseUid = userSaveRequest.FirebaseUid;
    }
}
