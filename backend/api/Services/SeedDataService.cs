using api.Data;
using api.Models;
using BCrypt.Net;
using Microsoft.EntityFrameworkCore;

namespace api.Services;

public class SeedDataService
{
    private readonly ApplicationDbContext _dbContext;

    public SeedDataService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public void PopulateDatabase()
    {
        if (!_dbContext.Users.Any())
        {
            GenerateUsers();
            GenerateDecks();
            GenerateStudySessions();
            GenerateAchievements();
        }
    }

    public void GenerateUsers()
    {
        var users = new List<User>();
        var random = new Random();

        for (int i = 0; i < 100; i++)
        {
            var username = "user" + i;
            var email = "user" + i + "@example.com";
            var passwordHashed = BCrypt.Net.BCrypt.HashPassword("test");
            var isPremium = false;
            var isAdmin = false;

            var user = new User
            {
                Username = username,
                Email = email,
                PasswordHashed = passwordHashed,
                IsPremium = isPremium,
                IsAdmin = isAdmin,
                CreatedAt = DateTime.Now.AddDays(-random.Next(1, 120)),
            };

            users.Add(user);
        }

        _dbContext.Users.AddRange(users);
        _dbContext.SaveChanges();
    }

    public void GenerateDecks() 
    {
        var userIds = _dbContext.Users
            .Select(u => u.Id)
            .ToList();

        var decks = new List<Deck>();
        var random = new Random();

        for (int i = 0; i < 500; i++)
        {
            var name = $"Deck {i + 1}";
            var userId = userIds[random.Next(userIds.Count)];

            var deck = new Deck
            {
                Name = name,
                UserId = userId
            };

            decks.Add(deck);
        }

        _dbContext.Decks.AddRange(decks);
        _dbContext.SaveChanges();
    }

    public void GenerateStudySessions()
    {
        var deckIds = _dbContext.Decks
            .Select(d => d.Id)
            .ToList();
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
                DeckId = deckIds[random.Next(deckIds.Count)],
                CardCount = cardCount,
                Duration = duration,
                AverageEaseFactor = easeFactor,
                AverageRepetitions = repetitions,
                StudiedAt = DateTime.Now.AddDays(-random.Next(1, 90)).AddHours(-random.Next(1, 24))
            };

            mockData.Add(studySession);
        }

        _dbContext.StudySessions.AddRange(mockData);
        _dbContext.SaveChanges();
    }

    public void GenerateAchievements()
    {
        var achievements = new List<Achievement>
        {
            new Achievement
            {
                Name = "Consistent Learner",
                Description = "Study every day for 30 consecutive days.",
                Icon = "consistent_learner.png"
            },
            new Achievement
            {
                Name = "First Steps",
                Description = "Finish your first study session.",
                Icon = "first_steps.png"
            },
            new Achievement
            {
                Name = "Committed Student",
                Description = "Finish 10 study sessions.",
                Icon = "commited_student.png"
            },
            new Achievement
            {
                Name = "Perfect Recall",
                Description = "Review all cards in a session without any mistakes.",
                Icon = "perfect_recall.png"
            },
            new Achievement
            {
                Name = "Daily Devotion",
                Description = "Study for 1 hour in one day.",
                Icon = "daily_devotion.png"
            },
            new Achievement
            {
                Name = "Early Bird",
                Description = "Complete a session between 4 AM and 7 AM.",
                Icon = "early_bird.png"
            },
            new Achievement
            {
                Name = "Night Owl",
                Description = "Complete a session between 10 PM and 3 AM.",
                Icon = "night_owl.png"
            },
            new Achievement
            {
                Name = "Speed Demon",
                Description = "Review 50 cards in less than 5 minutes.",
                Icon = "speed_demon.png"
            },
            new Achievement
            {
                Name = "Weekend Warrior",
                Description = "Study on consecutive Saturday and Sunday.",
                Icon = "weekend_warrior.png"
            },
            new Achievement
            {
                Name = "Flashcard Pro",
                Description = "Review 1000 cards in total.",
                Icon = "flashcard_pro.png"
            },
            new Achievement
            {
                Name = "Deck designer",
                Description = "Manually add 100 cards to your decks.",
                Icon = "deck_designer.png"
            },
        };

        _dbContext.Achievements.AddRange(achievements);
        _dbContext.SaveChanges();
    }
}
