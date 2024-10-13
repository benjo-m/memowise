namespace api.Models;

public class Deck
{
    public int Id { get; set; }
    public string Name { get; set; }
    public ICollection<Card> Cards { get; set; } = new List<Card>();
    public int UserId { get; set; }
    public User User { get; set; }
}
