namespace api.DTO;

public class DashboardData
{
    public TotalUsers TotalUsers { get; set; }
    public UserGrowthResponse UserGrowth { get; set; }
    public UserDistributionResponse UserDistribution { get; set; }
    public NewUsers NewUsers { get; set; }
    public ActiveUsers ActiveUsers { get; set; }
    public FeedbackCount FeedbackCount { get; set; }
}
