using System.Text.Json.Serialization;

namespace api.Models;

public class CardStats
{
    public int Id { get; set; }
    public int Repetitions { get; set; } = 0;
    public int Interval { get; set; } = 0;
    public float EaseFactor { get; set; } = 2.5f;
    public DateTime DueDate { get; set; } = DateTime.Now;
    public int CardId { get; set; }
    [JsonIgnore]
    public Card Card { get; set; }
}
