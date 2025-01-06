using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    [JsonIgnore]
    public string PasswordHashed { get; set; }
    public bool IsPremium { get; set; }
    public bool IsAdmin { get; set; }
    public ICollection<Deck> Decks { get; set; } = new List<Deck>();
    public List<Achievement> Achievements { get; set; } = [];
    [JsonIgnore]
    public UserStats UserStats { get; set; } = new UserStats();
    public DateTime CreatedAt { get; set; } = DateTime.Now;

    public User() {}

    public User(RegisterRequest registerRequest)
    {
        Username = registerRequest.Username;
        Email = registerRequest.Email;
        PasswordHashed = BCrypt.Net.BCrypt.HashPassword(registerRequest.Password);
    }

    public User(UserCreateRequest request) 
    {
        Username = request.Username;
        Email = request.Email;
        PasswordHashed = BCrypt.Net.BCrypt.HashPassword(request.Password);
        IsAdmin = request.IsAdmin;
        IsPremium = request.IsPremium;
        CreatedAt = request.CreatedAt;
    }

    public User Update(UserUpdateRequest request)
    {
        Username = request.Username;
        Email = request.Email;
        PasswordHashed = BCrypt.Net.BCrypt.HashPassword(request.Password);
        IsAdmin = request.IsAdmin;
        IsPremium = request.IsPremium;
        CreatedAt = request.CreatedAt;
        return this;
    }
}
