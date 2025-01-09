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
    public DbSet<LoginRecord> LoginRecords { get; set; }
    public DbSet<PaymentRecord> PaymentRecords { get; set; }
    public DbSet<Feedback> Feedbacks { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Achievement>()
            .HasIndex(a => a.Name)
            .IsUnique();

        modelBuilder.Entity<User>()
            .HasIndex(u => u.Username)
            .IsUnique();

        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        modelBuilder
            .Entity<Feedback>()
            .Property(f => f.FeedbackStatus)
            .HasConversion<string>();
    }
}
