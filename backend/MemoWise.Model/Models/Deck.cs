using System.Text.Json.Serialization;

namespace MemoWise.Model.Models;
using MemoWise.Model.DTO;

public class Deck
{
    public int Id { get; set; }
    public string Name { get; set; }
    public ICollection<Card> Cards { get; set; } = new List<Card>();
    public int UserId { get; set; }
    [JsonIgnore]
    public User User { get; set; }

    public Deck() { }

    public Deck(DeckCreateRequestWithCards deckCreateRequest)
    {
        Name = deckCreateRequest.Name;
        Cards = deckCreateRequest.Cards
            .Select(card => new Card(card))
            .ToList();
    }

    public Deck(DeckCreateRequest deck)
    {
        Name = deck.Name;
        UserId = deck.UserId;
    }

    public Deck Update(DeckUpdateRequest request)
    {
        Name = request.Name;
        UserId = request.UserId;
        return this;
    }
}
