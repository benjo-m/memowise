using api.Data;
using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class SeedDataService
{
    private readonly ApplicationDbContext _dbContext;

    public SeedDataService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public void GenerateMockStudySessions()
    {
        if (_dbContext.StudySessions.Any())
        {
            return;
        }

        var random = new Random();
        var mockData = new List<StudySession>();

        for (int i = 0; i < 500; i++)
        {
            var cardCount = random.Next(10, 51);
            var easeFactor = (float)Math.Round((random.NextDouble() * 1.4 + 1.3), 2);

            var duration = (int)((cardCount * 4) * (2.7 - easeFactor) * random.Next(15, 30));


            float repetitions = (float)Math.Round(random.NextDouble() * 2.7 + 1.3, 2);

            var studySession = new StudySession
            {
                UserId = random.Next(10, 20),
                CardCount = cardCount,
                Duration = duration,
                AverageEaseFactor = easeFactor,
                AverageRepetitions = repetitions,
                StudiedAt = DateTime.Now.AddDays(-random.Next(1, 30)).AddHours(-random.Next(1, 24))
            };

            mockData.Add(studySession);
        }

        _dbContext.StudySessions.AddRange(mockData);
        _dbContext.SaveChanges();
    }
}
