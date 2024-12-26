using api.DTO;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace api.Services;

public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    AuthService _authService;

    public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, AuthService authService) 
        : base(options, logger, encoder)
    {
        _authService = authService;
    }

    protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Request.Headers.ContainsKey("Authorization"))
        {
            return AuthenticateResult.Fail("Missing header");
        }

        var authHeader = AuthenticationHeaderValue.Parse(Request.Headers.Authorization!);
        var credentialsBytes = Convert.FromBase64String(authHeader.Parameter!);
        var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

        var username = credentials[0];
        var password = credentials[1];

        var user = await _authService.Login(new LoginRequest()
        {
            Username = username,
            Password = password
        });

        if (user == null)
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
