using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public class Deck
{
    public int Id { get; set; }
    public string Name { get; set; }
    public ICollection<Card> Cards { get; set; } = new List<Card>();
    public int UserId { get; set; }
    [JsonIgnore]
    public User User { get; set; }

    public Deck() {}

    public Deck(DeckCreateRequest deckCreateRequest)
    {
        Name = deckCreateRequest.Name;
        Cards = deckCreateRequest.Cards
            .Select(card => new Card(card))
            .ToList();
    }
}
