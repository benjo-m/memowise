using MemoWise.Model.Models;

namespace MemoWise.Model.DTO;

public class UnlockedAchievementsResponse
{
    public List<Achievement> Achievements { get; set; }
    public double Progress { get; set; }
}
