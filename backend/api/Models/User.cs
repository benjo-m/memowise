namespace api.Models;

public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public ICollection<Deck> Decks { get; set; } = new List<Deck>();
}
