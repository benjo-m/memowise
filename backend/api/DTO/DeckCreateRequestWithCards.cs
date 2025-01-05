using System.ComponentModel.DataAnnotations;

namespace api.DTO;

public class DeckCreateRequestWithCards
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; }
    public List<CardCreateRequest> Cards { get; set; }
}
