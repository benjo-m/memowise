using MemoWise.Model.Models;

namespace MemoWise.Model.DTO;

public class UserDto
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public bool IsPremium { get; set; }
    public bool IsAdmin { get; set; }
    public bool IsSuperAdmin { get; set; }

    public UserDto()
    {
    }

    public UserDto(User user)
    {
        Id = user.Id;
        Username = user.Username;
        Email = user.Email;
        IsPremium = user.IsPremium;
        IsAdmin = user.IsAdmin;
        IsSuperAdmin = user.IsSuperAdmin;
    }
}
