using System.ComponentModel.DataAnnotations;

namespace api.DTO;

public class RegisterRequest
{
    [Required]
    [MaxLength(50)]
    public string Username { get; set; }
    [Required]
    public string Email { get; set; }
    [Required]
    public string Password { get; set; }
    [Required]
    public string PasswordConfirmation { get; set; }
}
