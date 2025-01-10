using api.DTO;
using System.Text.Json.Serialization;

namespace api.Models;

public class LoginRecord
{
    public int Id { get; set; }
    public int UserId { get; set; }
    [JsonIgnore]
    public User User { get; set; }
    public DateTime LoginDateTime { get; set; }

    public LoginRecord()
    {
    }

    public LoginRecord(LoginRecordCreateRequest request)
    {
        UserId = request.UserId;
        LoginDateTime = request.LoginDateTime;
    }

    public LoginRecord Update(LoginRecordUpdateRequest request)
    {
        UserId = request.UserId;
        LoginDateTime = request.LoginDateTime;
        return this;
    }
}
