using MemoWise.Model.DTO;
using MemoWise.SubscriberEmail;
using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;

public class Program
{
    public static async Task Main(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddUserSecrets<Program>()
            .AddEnvironmentVariables()
            .Build();
        var rabbitMqHost = configuration["RABBITMQ_HOST"] ?? "localhost";
        var rabbitMqPort = configuration["RABBITMQ_PORT"] ?? "5672";
        var rabbitMqUser = configuration["RABBITMQ_DEFAULT_USER"] ?? "guest";
        var rabbitMqPass = configuration["RABBITMQ_DEFAULT_PASS"] ?? "guest";
        var rabbitMqQueue = configuration["RABBITMQ_QUEUE"] ?? "email";

        var emailService = new EmailService(configuration);

        var factory = new ConnectionFactory
        {
            HostName = rabbitMqHost,
            Port = int.Parse(rabbitMqPort),
            UserName = rabbitMqUser,
            Password = rabbitMqPass
        }; 
        using var connection = await factory.CreateConnectionAsync();
        using var channel = await connection.CreateChannelAsync();

        await channel.QueueDeclareAsync(queue: rabbitMqQueue, durable: false, exclusive: false, autoDelete: false,
            arguments: null);

        Console.WriteLine("Waiting for messages...");

        var consumer = new AsyncEventingBasicConsumer(channel);
        consumer.ReceivedAsync += async (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            var recipient = JsonSerializer.Deserialize<EmailRecipient>(message);
            await emailService.SendEmail(recipient!);
            Console.WriteLine($"Email sent to {recipient!.Email}");
        };

        await channel.BasicConsumeAsync(rabbitMqQueue, autoAck: true, consumer: consumer);

        await Task.Delay(Timeout.Infinite);
    }
}