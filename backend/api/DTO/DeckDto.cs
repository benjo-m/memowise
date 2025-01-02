using api.Models;

namespace api.DTO;

public class DeckDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int UserId { get; set; }

    public DeckDto()
    {
    }

    public DeckDto(Deck deck)
    {
        Id = deck.Id;
        Name = deck.Name;
        UserId = deck.UserId;
    }
}
