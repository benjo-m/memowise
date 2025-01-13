using api.Data;
using MemoWise.Model.Models;

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
            GenerateFeedback();
        }
    }

    public void GenerateUsers()
    {
        var users = new List<User>();
        var random = new Random();

        var superAdmin = new User
        {
            Username = "super_admin",
            Email = "sa@ex.com",
            PasswordHashed = BCrypt.Net.BCrypt.HashPassword("test"),
            IsPremium = false,
            IsAdmin = true,
            IsSuperAdmin = true,
            CreatedAt = DateTime.Now.AddDays(-random.Next(1, 120)),
        };

        var admin = new User
        {
            Username = "admin1",
            Email = "admin@ex.com",
            PasswordHashed = BCrypt.Net.BCrypt.HashPassword("test"),
            IsPremium = false,
            IsAdmin = true,
            IsSuperAdmin = false,
            CreatedAt = DateTime.Now.AddDays(-random.Next(1, 120)),
        };

        users.Add(superAdmin);
        users.Add(admin);

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

    public List<Feedback> GenerateFeedback()
    {
        var titles = new[]
        {
        "Improve User Interface", "Feature Request: Dark Mode", "Bug Report: Login Issue",
        "Database Optimization Needed", "Feedback on Customer Support", "Add Export Feature",
        "Enhance Security Options", "Mobile App Improvements", "Request for API Documentation",
        "Enhance Analytics Dashboard", "Improve Notification System", "Add Multi-language Support",
        "Add Payment Gateway Integration", "Feedback on Training Materials", "Improve Search Functionality",
        "Suggestion for New Themes", "Add Two-factor Authentication", "Feedback on Performance Issues",
        "Feature Request: Offline Mode", "Update Privacy Policy"
    };

        var descriptions = new[]
        {
        "The user interface currently feels outdated and non-intuitive. Modernizing the UI with a cleaner and more accessible design could greatly enhance user experience and make navigation more seamless.",
        "Many users have requested a dark mode feature to reduce eye strain, especially when using the application at night. This feature has become a standard in modern applications and could significantly improve user satisfaction.",
        "There seems to be a recurring issue with the login process where users encounter timeout errors. This bug is not only frustrating but could lead to potential loss of users if not resolved promptly.",
        "The current database queries are slow and could benefit from optimization. Indexing frequently queried columns or rewriting complex queries might help improve overall performance.",
        "Customer support is responsive, but there is room for improvement in terms of resolution times. Implementing a better ticketing system could streamline the process and increase user trust.",
        "An export feature would allow users to save their data in various formats such as CSV or PDF. This would be especially useful for businesses that need to analyze their data offline.",
        "Security is a top concern for our users. Enhancing options such as biometric authentication and better encryption protocols will ensure user data remains secure.",
        "The mobile app could use several improvements, such as faster load times and better optimization for different screen sizes. Users have also reported crashes on older devices.",
        "The API documentation is currently incomplete and difficult to follow. Providing clear examples, detailed descriptions, and updated versions of the documentation will make it easier for developers to integrate.",
        "The analytics dashboard lacks detailed reporting features. Adding more customizable reports and visualizations will allow users to gain deeper insights into their data.",
        "Notifications are often delayed or sometimes not received by users. Ensuring real-time delivery and adding more notification settings will enhance the reliability of this feature.",
        "Multi-language support is critical for reaching a global audience. Adding translations for key languages and ensuring they are contextually accurate will greatly expand the application's user base.",
        "Integrating a payment gateway would streamline the checkout process and allow users to make payments directly within the app. This feature is essential for e-commerce functionality.",
        "The training materials provided are helpful but lack depth in certain areas. Adding more video tutorials and interactive examples would make the learning process much more engaging.",
        "The search functionality currently does not return relevant results for many queries. Improving the algorithm and adding filters will make it easier for users to find what they are looking for.",
        "Users have requested the ability to customize themes to better suit their preferences. Providing multiple pre-built themes and an option to create custom ones would greatly enhance personalization.",
        "Two-factor authentication is a critical security feature that is currently missing. Adding this feature will significantly reduce the risk of unauthorized account access.",
        "Performance issues have been reported, especially during peak usage times. Optimizing server resources and implementing load balancing could help address these problems.",
        "Offline mode is a highly requested feature, especially for users who work in environments with limited connectivity. Allowing users to access and edit their data offline would add tremendous value.",
        "The privacy policy needs to be updated to ensure compliance with GDPR and other data protection regulations. Providing users with clear information about how their data is used is crucial for building trust."
    };

        var userIds = _dbContext.Users
            .Select(u => u.Id)
            .ToList();

        var random = new Random();
        var feedbackList = new List<Feedback>();

        for (int i = 0; i < titles.Length; i++)
        {
            feedbackList.Add(new Feedback
            {
                Title = titles[i],
                Description = descriptions[i],
                SubmittedAt = DateTime.Now.AddMinutes(-random.Next(0, 100000)),
                UserId = userIds[random.Next(userIds.Count)]
            });
        }

        _dbContext.AddRangeAsync(feedbackList);
        _dbContext.SaveChanges();

        return feedbackList;
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
                Name = "Deck Designer",
                Description = "Manually add 100 cards to your decks.",
                Icon = "deck_designer.png"
            },
        };

        _dbContext.Achievements.AddRange(achievements);
        _dbContext.SaveChanges();
    }
}
