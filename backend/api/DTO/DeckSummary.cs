using api.Models;

namespace api.DTO;

public class DeckSummary
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int NewCards { get; set; }
    public int LearningCards { get; set; }
    public int ReviewingCards { get; set; }

    public int LearnedCards { get; set; }

    public DeckSummary() { }

    public DeckSummary(Deck deck)
    {
        Id = deck.Id;
        Name = deck.Name;
        NewCards = deck.Cards
            .Where(c => c.Status == CardStatus.New)
            .Count();
        LearningCards = deck.Cards
            .Where(c => c.Status == CardStatus.Learning)
            .Count();
        LearningCards = deck.Cards
            .Where(c => c.Status == CardStatus.Rewieving)
            .Count();
        LearnedCards = deck.Cards
            .Where(c => c.Status == CardStatus.Learned)
            .Count();
    }
}
