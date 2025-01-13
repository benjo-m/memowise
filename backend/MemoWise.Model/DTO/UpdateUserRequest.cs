using System.ComponentModel.DataAnnotations;

namespace MemoWise.Model.DTO;

public class UpdateUserRequest
{
    [MaxLength(50)]
    public string Username { get; set; }
    [Required]
    public string Email { get; set; }
}
