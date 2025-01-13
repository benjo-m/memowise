using System.Text.Json.Serialization;
namespace MemoWise.Model.Models;

using BCrypt.Net;
using MemoWise.Model.DTO;


public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    [JsonIgnore]
    public string PasswordHashed { get; set; }
    public bool IsPremium { get; set; }
    public bool IsAdmin { get; set; }
    public bool IsSuperAdmin { get; set; }
    public ICollection<Deck> Decks { get; set; } = new List<Deck>();
    [JsonIgnore]
    public UserStats UserStats { get; set; } = new UserStats();
    public DateTime CreatedAt { get; set; } = DateTime.Now;
    public List<Achievement> Achievements { get; set; } = [];
    public ICollection<Feedback> Feedbacks { get; set; } = new List<Feedback>();
    public ICollection<LoginRecord> LoginRecords { get; set; } = new List<LoginRecord>();
    public ICollection<PaymentRecord> PaymentRecords {  get; set; } = new List<PaymentRecord>();

    public User() {}

    public User(RegisterRequest registerRequest)
    {
        Username = registerRequest.Username;
        Email = registerRequest.Email;
        PasswordHashed = BCrypt.HashPassword(registerRequest.Password);
    }

    public User(UserCreateRequest request) 
    {
        Username = request.Username;
        Email = request.Email;
        PasswordHashed = BCrypt.HashPassword(request.Password);
        IsAdmin = request.IsAdmin;
        IsPremium = request.IsPremium;
        CreatedAt = request.CreatedAt;
    }

    public User Update(UserUpdateRequest request)
    {
        Username = request.Username;
        Email = request.Email;
        IsAdmin = request.IsAdmin;
        IsPremium = request.IsPremium;
        CreatedAt = request.CreatedAt;
        return this;
    }
}
