using MailKit.Net.Smtp;
using MailKit.Security;
using MemoWise.Model.DTO;
using Microsoft.Extensions.Configuration;
using MimeKit;

namespace MemoWise.SubscriberEmail;
internal class EmailService
{
    private readonly IConfiguration _configuration;

    public EmailService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task SendEmail(EmailRecipient recipient)
    {
        try
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("MemoWise", _configuration["EMAIL"]!));
            message.To.Add(new MailboxAddress(recipient.Username, recipient.Email));
            message.Subject = "Welcome!";

            var bodyBuilder = new BodyBuilder
            {
                TextBody = $@"Hi {recipient.Username},

                Welcome to MemoWise! 🎉 We're happy to have you
                MemoWise is designed to help you study more efficiently and to keep you motivated to study every day, whether you're studying for exams or just learning new things, we're here to support your journey.
                Since MemoWise is open source and licensed under MIT, you're welcome to contribute to its growth and improvement. Whether you want to fix bugs, suggest new features, or enhance existing ones, we'd love to have your input
                Check out our GitHub repository here:
                🔗 https://github.com/benjo-m/
                Thank you for joining, and welcome aboard
                Best regards,
                The MemoWise Team",
                HtmlBody = $@"<p>Hi <strong>{recipient.Username}</strong>,</p>
                <p>Welcome to <strong>MemoWise</strong>! 🎉 We're happy to have you.</p>
                <p>MemoWise is designed to help you study more efficiently and to keep you motivated to study every day, whether you're studying for exams or just learning new things, we're here to support your journey.</p>
                <p>Since MemoWise is open source and licensed under MIT, you're welcome to contribute to its growth and improvement. Whether you want to fix bugs, suggest new features, or enhance existing ones, we'd love to have your input!</p>
                <p>Check out the GitHub repository here: <a href='https://github.com/benjo-m/memowise'>🔗 https://github.com/benjo-m/memowise</a></p>
                <p>Thank you for joining, and welcome aboard! 😊</p>"
            };

            message.Body = bodyBuilder.ToMessageBody();


            using (var client = new SmtpClient())
            {
                await client.ConnectAsync(_configuration["SMTP_SERVER"]!, int.Parse(_configuration["SMTP_PORT"]!), SecureSocketOptions.StartTls);
                await client.AuthenticateAsync(_configuration["EMAIL"]!, _configuration["APP_PASSWORD"]!);
                await client.SendAsync(message);
                await client.DisconnectAsync(true);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error sending email: {ex.Message}");
        }
    }
}
