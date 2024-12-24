using api.Exceptions;

public class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;

    public ExceptionHandlingMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task Invoke(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (UsernameTakenException ex)
        {
            context.Response.StatusCode = StatusCodes.Status409Conflict;
            await context.Response.WriteAsJsonAsync(new { errorCode = "USERNAME_TAKEN", message = ex.Message });
        }
        catch (EmailAlreadyInUseException ex)
        {
            context.Response.StatusCode = StatusCodes.Status409Conflict;
            await context.Response.WriteAsJsonAsync(new { errorCode = "EMAIL_TAKEN", message = ex.Message });
        }
        catch (WrongPasswordException)
        {
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        }
        catch (ResourceForbiddenException ex)
        {
            context.Response.StatusCode = StatusCodes.Status403Forbidden;
            await context.Response.WriteAsJsonAsync(new { errorCode = "RESOURCE_FORBBIDEN", message = ex.Message });
        }
        catch (PasswordsNotMatchingException)
        {
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        }
        catch (NonPremiumLimitException ex)
        {
            context.Response.StatusCode = StatusCodes.Status403Forbidden;
            await context.Response.WriteAsJsonAsync(new { errorCode = "NON_PREMIUM_LIMIT_EXCEEDED", message = ex.Message });
        }
        catch (AlreadyPremiumException ex)
        {
            context.Response.StatusCode = StatusCodes.Status403Forbidden;
            await context.Response.WriteAsJsonAsync(new { errorCode = "ALREADY_PREMIUM", message = ex.Message });
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = StatusCodes.Status500InternalServerError;
            await context.Response.WriteAsJsonAsync(new { message = "An unexpected error occurred.", details = ex.Message });
        }
    }
}