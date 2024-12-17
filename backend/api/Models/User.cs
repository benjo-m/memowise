using api.DTO;

namespace api.Models;

public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string PasswordHashed { get; set; }
    public ICollection<Deck> Decks { get; set; } = new List<Deck>();

    public User() {}

    public User(RegisterRequest registerRequest)
    {
        Username = registerRequest.Username;
        Email = registerRequest.Email;
        PasswordHashed = BCrypt.Net.BCrypt.HashPassword(registerRequest.Password);
    }
}
