using Microsoft.EntityFrameworkCore;
using api.Models;

namespace api.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext (DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Deck> Decks { get; set; }
    public DbSet<Card> Cards { get; set; }
    public DbSet<CardStats> CardStats { get; set; }
    public DbSet<StudySession> StudySessions { get; set; }
    public DbSet<Achievement> Achievements { get; set; }
    public DbSet<UserStats> UserStats { get; set; }
    public DbSet<ImageRecord> ImageRecords { get; set; }
}
