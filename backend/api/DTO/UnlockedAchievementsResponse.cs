using api.Models;

namespace api.DTO;

public class UnlockedAchievementsResponse
{
    public List<Achievement> Achievements { get; set; }
    public double Progress { get; set; }
}
