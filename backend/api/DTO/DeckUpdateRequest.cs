using System.ComponentModel.DataAnnotations;

namespace api.DTO;

public class DeckUpdateRequest
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; }
}
