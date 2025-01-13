using System.ComponentModel.DataAnnotations;

namespace MemoWise.Model.DTO;

public class DeckUpdateRequest
{
    [Required]
    [MaxLength(100)]
    public string Name { get; set; }
    public int UserId { get; set; }
}
