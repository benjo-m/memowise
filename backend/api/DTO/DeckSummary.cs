using api.Models;

namespace api.DTO;

public class DeckSummary
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int NewCards { get; set; }
    public int LearningCards { get; set; }
    public int LearnedCards { get; set; }

    public DeckSummary() { }

    public DeckSummary(Deck deck)
    {
        Id = deck.Id;
        Name = deck.Name;
        NewCards = deck.Cards
            .Where(card => card.CardStats.Interval == 0)
            .Count();
        LearningCards = deck.Cards
            .Where(card => card.CardStats.Interval > 0 
                && DateTime.Compare(card.CardStats.DueDate, DateTime.Now) < 0)
            .Count();
        LearnedCards = deck.Cards
            .Where(card => card.CardStats.Interval > 0
                && DateTime.Compare(card.CardStats.DueDate, DateTime.Now) > 0)
            .Count();
    }
}
