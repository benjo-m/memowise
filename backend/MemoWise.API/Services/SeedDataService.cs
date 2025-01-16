using api.Data;
using MemoWise.Model.Models;
using Microsoft.Identity.Client;
using System;

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
            GenerateAchievementUser();
            GenerateLoginRecords();
            GenerateDemoUser();
        }
    }

    public void GenerateUsers()
    {
        var users = new List<User>();
        var random = new Random();

        var superAdmin = new User
        {
            Username = "super_admin",
            Email = "super@admin.com",
            PasswordHashed = BCrypt.Net.BCrypt.HashPassword("password"),
            IsPremium = false,
            IsAdmin = true,
            IsSuperAdmin = true,
            CreatedAt = DateTime.Now.AddDays(-random.Next(1, 120)),
        };

        var admin = new User
        {
            Username = "admin1",
            Email = "admin@ex.com",
            PasswordHashed = BCrypt.Net.BCrypt.HashPassword("password"),
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
            var passwordHashed = BCrypt.Net.BCrypt.HashPassword("password");
            var isAdmin = false;
            var userStats = new UserStats
            {
                TotalDecksCreated = random.Next(20, 50),
                TotalDecksGenerated = random.Next(0, 20),
                TotalCardsCreated = random.Next(0, 500),
                TotalCardsLearned = random.Next(0, 500),
                StudyStreak = random.Next(0, 20),
                LongestStudyStreak = random.Next(20, 50),
                TotalSessionsCompleted = random.Next(0, 200),
                TotalCorrectAnswers = random.Next(0, 1000)
            };

            var user = new User
            {
                Username = username,
                Email = email,
                PasswordHashed = passwordHashed,
                IsPremium = i % 10 == 0,
                IsAdmin = isAdmin,
                CreatedAt = DateTime.Now.AddDays(-random.Next(1, 120)),
                UserStats = userStats
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

        for (int i = 0; i < 250; i++)
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
        var studySessions = new List<StudySession>();

        for (int i = 0; i < 500; i++)
        {
            var cardCount = random.Next(10, 51);
            var easeFactor = (float)Math.Round((random.NextDouble() * 1.4 + 1.3), 2);
            //var duration = (int)((cardCount * 7) * (2.7 - easeFactor) * random.Next(15, 30));
            var duration = cardCount * random.Next(15, 60);
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

            studySessions.Add(studySession);
        }

        _dbContext.StudySessions.AddRange(studySessions);
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
                UserId = userIds[random.Next(userIds.Count)],
                IsPremiumUser = i % 6 == 0
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
                Description = "Manually add 1000 cards to your decks.",
                Icon = "deck_designer.png"
            },
        };

        _dbContext.Achievements.AddRange(achievements);
        _dbContext.SaveChanges();
    }

    public void GenerateAchievementUser()
    {
        var random = new Random();
        var allUsers = _dbContext.Users.ToList();
        var allAchievements = _dbContext.Achievements.ToList();

        var achievementUsers = new List<AchievementUser>();

        foreach (var user in allUsers)
        {
            int achievementsToUnlock = random.Next(1, allAchievements.Count / 2);

            var unlockedAchievements = allAchievements
                .OrderBy(a => random.Next())
                .Take(achievementsToUnlock);

            foreach (var achievement in unlockedAchievements)
            {
                achievementUsers.Add(new AchievementUser
                {
                    UserId = user.Id,
                    AchievementId = achievement.Id,
                });
            }
        }

        _dbContext.AchievementUsers.AddRange(achievementUsers);
        _dbContext.SaveChanges();
    }

    public void GenerateLoginRecords()
    {
        var random = new Random();
        var users = _dbContext.Users.ToList();
        var loginRecords = new List<LoginRecord>();

        foreach (var user in users)
        {
            int numberOfLogins = random.Next(1, 11);

            for (int i = 0; i < numberOfLogins; i++)
            {
                var loginDate = DateTime.Now.AddDays(-random.Next(1, 121));
                var loginRecord = new LoginRecord
                {
                    UserId = user.Id,
                    LoginDateTime = loginDate
                };

                loginRecords.Add(loginRecord);
            }
        }

        _dbContext.LoginRecords.AddRange(loginRecords);
        _dbContext.SaveChanges();
    }

    public void GenerateDemoUser()
    {
        var demoUser = new User
        {
            Username = "user",
            Email = "user@user.com",
            PasswordHashed = BCrypt.Net.BCrypt.HashPassword("password"),
            IsPremium = false,
            IsAdmin = false,
            IsSuperAdmin = false,
            CreatedAt = DateTime.Now.AddDays(-7),
            UserStats = new UserStats
            {
                LongestStudyStreak = 15,
                TotalDecksCreated = 20,
                TotalDecksGenerated = 7,
                TotalCardsCreated = 229,
                TotalCardsLearned = 201,
            }
        };

        _dbContext.Users.Add(demoUser);
        _dbContext.SaveChanges();

        var unlockedAchievements = new List<AchievementUser>
        {
            new AchievementUser
            {
                UserId = demoUser.Id,
                AchievementId = 2
            },
            new AchievementUser
            {
                UserId = demoUser.Id,
                AchievementId = 3
            },
        };

        _dbContext.AchievementUsers.AddRange(unlockedAchievements);

        var geographyDeck = new Deck
        {
            Name = "Geography",
            UserId = demoUser.Id,
        };

        var historyDeck = new Deck
        {
            Name = "History",
            UserId = demoUser.Id,
        };

        var scienceDeck = new Deck
        {
            Name = "Science",
            UserId = demoUser.Id,
        };

        _dbContext.Decks.Add(geographyDeck);
        _dbContext.Decks.Add(historyDeck);
        _dbContext.Decks.Add(scienceDeck);
        _dbContext.SaveChanges();

        var geographyCards = new List<Card>
{
    new Card
    {
        Question = "What is the Ring of Fire?",
        Answer = "The Ring of Fire is a major area in the Pacific Ocean basin where a large number of earthquakes and volcanic eruptions occur. It is shaped like a horseshoe and includes over 450 volcanoes, making it the world's most seismically active region. This is due to tectonic plate boundaries and subduction zones along the edges of the Pacific Plate.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What is the significance of the Amazon Rainforest?",
        Answer = "The Amazon Rainforest, often referred to as the 'lungs of the Earth,' is the largest tropical rainforest in the world. Spanning over 5.5 million square kilometers across nine countries in South America, it plays a crucial role in regulating the Earth's oxygen and carbon cycles, housing millions of species, and supporting indigenous cultures.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What are the Great Plains in North America?",
        Answer = "The Great Plains are a vast expanse of flatland covering parts of the United States and Canada. Known for their fertile soil, they are a major agricultural region, producing large amounts of wheat and corn. The Plains are also significant for their historical role in Native American cultures and the westward expansion of settlers.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What causes the phenomenon of monsoons?",
        Answer = "Monsoons are seasonal wind patterns caused by differences in temperature between landmasses and adjacent oceans. For example, in South Asia, during the summer, warm land masses create low-pressure systems that draw in moist air from the Indian Ocean, resulting in heavy rainfall. This cycle reverses during winter, leading to dry conditions.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What is the significance of the Himalayas?",
        Answer = "The Himalayas are the highest mountain range in the world, containing Mount Everest, the Earth's tallest peak. They act as a natural barrier between the Indian subcontinent and the rest of Asia, influence regional climates by blocking cold winds, and are a crucial source of water for major rivers like the Ganges, Indus, and Brahmaputra.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What is the importance of the Sahara Desert?",
        Answer = "The Sahara Desert is the largest hot desert in the world, spanning about 9.2 million square kilometers across North Africa. It influences regional climates and is a significant source of mineral-rich dust that fertilizes ecosystems like the Amazon Rainforest. Despite its harsh conditions, it supports unique flora and fauna adapted to arid environments.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What are tectonic plates?",
        Answer = "Tectonic plates are massive slabs of Earth's lithosphere that float on the semi-fluid mantle beneath them. Their movement is responsible for geological phenomena such as earthquakes, volcanic activity, and the formation of mountain ranges. Plate boundaries can be divergent, convergent, or transform, leading to specific types of geological events.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "Why is the Nile River significant?",
        Answer = "The Nile River, stretching over 6,650 kilometers, is the longest river in the world and a lifeline for northeastern Africa. It has historically supported civilizations like Ancient Egypt by providing water for agriculture, transportation, and trade. Today, it remains critical for modern countries' water and energy needs through projects like the Aswan High Dam.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What is a biome?",
        Answer = "A biome is a large geographical area characterized by specific climate conditions, plants, and animals. Examples include tropical rainforests, deserts, tundras, and grasslands. Biomes are shaped by temperature, precipitation, and geography, and they play a crucial role in sustaining Earth's biodiversity and ecological balance.",
        DeckId = geographyDeck.Id
    },
    new Card
    {
        Question = "What is the importance of the equator?",
        Answer = "The equator is an imaginary line that divides the Earth into the Northern and Southern Hemispheres. It lies at 0 degrees latitude and is significant because it receives the most direct sunlight year-round, leading to consistently warm temperatures. Regions near the equator are characterized by tropical climates and high biodiversity.",
        DeckId = geographyDeck.Id
    }
};

        var historyCards = new List<Card>
        {
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What event started World War I?",
                Answer = "World War I began after the assassination of Archduke Franz Ferdinand of Austria-Hungary in Sarajevo on June 28, 1914."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "Who was the first President of the United States?",
                Answer = "George Washington, a Founding Father and commander-in-chief of the Continental Army, served as the first President from 1789 to 1797."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the significance of the Magna Carta?",
                Answer = "Signed in 1215, the Magna Carta limited the power of the English monarch and established the principle that everyone is subject to the law."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What caused the fall of the Roman Empire?",
                Answer = "The fall of the Roman Empire in 476 AD was due to a combination of internal corruption, economic troubles, and invasions by barbarian tribes like the Visigoths."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "Who was Napoleon Bonaparte?",
                Answer = "Napoleon Bonaparte was a French military leader and emperor who rose to prominence during the French Revolution and led France from 1804 to 1815."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the Industrial Revolution?",
                Answer = "The Industrial Revolution was a period in the late 18th and early 19th centuries when industries transitioned to machine-based production, starting in Britain."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the Cold War?",
                Answer = "The Cold War was a geopolitical tension between the United States and the Soviet Union from 1947 to 1991, marked by ideological conflict and nuclear arms race."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the significance of the Battle of Hastings in 1066?",
                Answer = "The Battle of Hastings marked the Norman conquest of England, with William the Conqueror defeating King Harold II to become King of England."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the significance of the Declaration of Independence?",
                Answer = "Adopted on July 4, 1776, the Declaration of Independence proclaimed the thirteen American colonies' separation from British rule."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "Who was Cleopatra?",
                Answer = "Cleopatra VII was the last active ruler of the Ptolemaic Kingdom of Egypt, known for her political alliances and relationships with Julius Caesar and Mark Antony."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the Renaissance?",
                Answer = "The Renaissance was a cultural movement from the 14th to the 17th century that began in Italy and emphasized art, science, and the rediscovery of classical knowledge."
            },
            new Card
            {
                DeckId = historyDeck.Id,
                Question = "What was the purpose of the Berlin Wall?",
                Answer = "The Berlin Wall, constructed in 1961, divided East and West Berlin and symbolized the ideological conflict between Communism and Democracy during the Cold War."
            }
        };

        var scienceCards = new List<Card>
        {
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is Newton's First Law of Motion?",
                Answer = "Newton's First Law, also known as the Law of Inertia, states that an object will remain at rest or in uniform motion in a straight line unless acted upon by an external force."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the difference between a molecule and a compound?",
                Answer = "A molecule is formed when two or more atoms join together chemically, while a compound is a molecule that contains at least two different types of elements."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is photosynthesis?",
                Answer = "Photosynthesis is the process by which green plants, algae, and some bacteria convert sunlight, carbon dioxide, and water into glucose and oxygen."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the function of DNA in living organisms?",
                Answer = "DNA, or deoxyribonucleic acid, stores genetic information that guides the development, functioning, and reproduction of living organisms."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the theory of evolution?",
                Answer = "The theory of evolution, proposed by Charles Darwin, explains that species evolve over time through natural selection, where advantageous traits are passed on to offspring."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the difference between speed and velocity?",
                Answer = "Speed is the rate at which an object covers distance, while velocity is speed with a specific direction."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the periodic table?",
                Answer = "The periodic table is a tabular arrangement of chemical elements, ordered by increasing atomic number, electron configuration, and recurring chemical properties."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the water cycle?",
                Answer = "The water cycle describes the continuous movement of water on, above, and below the Earth's surface, involving processes like evaporation, condensation, and precipitation."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is a black hole?",
                Answer = "A black hole is a region in space where the gravitational pull is so strong that nothing, not even light, can escape its event horizon."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is an ecosystem?",
                Answer = "An ecosystem is a community of living organisms interacting with each other and their non-living environment, functioning as a unit."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the difference between mitosis and meiosis?",
                Answer = "Mitosis is a type of cell division that produces two identical daughter cells, while meiosis produces four genetically diverse gametes for sexual reproduction."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the Big Bang Theory?",
                Answer = "The Big Bang Theory is the leading explanation for the origin of the universe, stating it began as a singularity approximately 13.8 billion years ago and expanded over time."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What is the law of conservation of energy?",
                Answer = "The law of conservation of energy states that energy cannot be created or destroyed; it can only be transformed from one form to another or transferred between objects."
            },
            new Card
            {
                DeckId = scienceDeck.Id,
                Question = "What are the three states of matter?",
                Answer = "The three primary states of matter are solid, liquid, and gas. Solids have a fixed shape, liquids take the shape of their container, and gases fill the space they occupy."
            }
        };

        _dbContext.Cards.AddRange(geographyCards);
        _dbContext.Cards.AddRange(historyCards);
        _dbContext.Cards.AddRange(scienceCards);

        _dbContext.SaveChanges();

        var studySessions = new List<StudySession>
        {
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = geographyDeck.Id,
                Duration = 1380,
                CardCount = 10,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 0,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = geographyDeck.Id,
                Duration = 1380,
                CardCount = 10,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 0,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = geographyDeck.Id,
                Duration = 1380,
                CardCount = 10,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 0,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },

            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = historyDeck.Id,
                Duration = 1580,
                CardCount = 12,
                AverageEaseFactor = 2.2f,
                AverageRepetitions = 2.0f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 0,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = historyDeck.Id,
                Duration = 1380,
                CardCount = 12,
                AverageEaseFactor = 2.2f,
                AverageRepetitions = 1f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 0,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = historyDeck.Id,
                Duration = 1480,
                CardCount = 10,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 3,
                CardsRated2 = 2,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = historyDeck.Id,
                Duration = 1580,
                CardCount = 10,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 1,
                CardsRated2 = 2,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },

            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = scienceDeck.Id,
                Duration = 1580,
                CardCount = 14,
                AverageEaseFactor = 2.2f,
                AverageRepetitions = 2.0f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 0,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = scienceDeck.Id,
                Duration = 1380,
                CardCount = 10,
                AverageEaseFactor = 2.2f,
                AverageRepetitions = 1f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 3,
                CardsRated2 = 0,
                CardsRated3 = 3,
                CardsRated4 = 5,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = scienceDeck.Id,
                Duration = 1480,
                CardCount = 14,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 3,
                CardsRated2 = 2,
                CardsRated3 = 3,
                CardsRated4 = 4,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = scienceDeck.Id,
                Duration = 1580,
                CardCount = 12,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 1,
                CardsRated2 = 2,
                CardsRated3 = 3,
                CardsRated4 = 2,
                CardsRated5 = 5,
            },
            new StudySession
            {
                UserId = demoUser.Id,
                DeckId = scienceDeck.Id,
                Duration = 1580,
                CardCount = 14,
                AverageEaseFactor = 2.0f,
                AverageRepetitions = 1.4f,
                StudiedAt = DateTime.Now.AddDays(3),
                CardsRated1 = 1,
                CardsRated2 = 2,
                CardsRated3 = 3,
                CardsRated4 = 4,
                CardsRated5 = 5,
            },
        };

        _dbContext.StudySessions.AddRange(studySessions);

        _dbContext.SaveChanges();
    }
}
