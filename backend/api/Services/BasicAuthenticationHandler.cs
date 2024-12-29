using api.Data;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace api.Services;

public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    private readonly ApplicationDbContext _dbContext;

    public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ApplicationDbContext dbContext) 
        : base(options, logger, encoder)
    {
        _dbContext = dbContext;
    }

    protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        var endpoint = Context.GetEndpoint();

        if (endpoint?.Metadata?.GetMetadata<IAllowAnonymous>() != null)
        {
            return AuthenticateResult.NoResult();
        }

        if (!Request.Headers.ContainsKey("Authorization"))
        {
            return AuthenticateResult.Fail("Missing header");
        }

        var authHeader = AuthenticationHeaderValue.Parse(Request.Headers.Authorization!);
        var credentialsBytes = Convert.FromBase64String(authHeader.Parameter!);
        var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

        var username = credentials[0];
        var password = credentials[1];

        var user = await _dbContext.Users
            .Include(u => u.UserStats)
            .Where(u => u.Username == username)
            .FirstOrDefaultAsync();

        if (user == null || !BCrypt.Net.BCrypt.Verify(password, user.PasswordHashed))
        {
            return AuthenticateResult.Fail("Auth failed");
        }
        else
        {
            var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            };
            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);
            
            return AuthenticateResult.Success(ticket);
        }
    }
}
