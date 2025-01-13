using System.ComponentModel.DataAnnotations;

namespace MemoWise.Model.DTO;

public class GenerateCardsRequest
{
    [Required]
    [MaxLength(100)]
    public string Topic { get; set; }
    [Required]
    [Range(1, 30)]
    public int CardCount { get; set; }
}
