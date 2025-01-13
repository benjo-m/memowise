using System.ComponentModel.DataAnnotations;

namespace MemoWise.Model.DTO;

public class DeckCreateRequestWithCards
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; }
    public List<CardAddRequest> Cards { get; set; }
}
