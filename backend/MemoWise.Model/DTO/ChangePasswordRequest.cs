using System.ComponentModel.DataAnnotations;

namespace MemoWise.Model.DTO;

public class ChangePasswordRequest
{
    public string CurrentPassword { get; set; }
    [MinLength(6)]
    public string NewPassword { get; set; }
}
