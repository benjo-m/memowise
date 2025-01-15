namespace MemoWise.Model.Models;
public class AchievementUser
{
    public int UserId { get; set; }
    public User User { get; set; }
    public int AchievementId { get; set; }
    public Achievement Achievement { get; set; }
}
