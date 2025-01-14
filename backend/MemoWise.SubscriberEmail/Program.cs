using EasyNetQ;
using MemoWise.Model.DTO;
using MemoWise.SubscriberEmail;
using Microsoft.Extensions.Configuration;

public class Program
{
    public static async Task Main(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddUserSecrets<Program>()
            .AddEnvironmentVariables()
            .Build();
        var emailService = new EmailService(configuration);
        var bus = RabbitHutch.CreateBus("host=localhost");

        await bus.PubSub.SubscribeAsync<EmailRecipient>("email_queue", async recipient => await emailService.SendEmail(recipient));

        Console.WriteLine("Listening for messages...");
        Console.ReadLine();
    }
}