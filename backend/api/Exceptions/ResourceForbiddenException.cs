namespace api.Exceptions;

public class ResourceForbiddenException : Exception
{
    public ResourceForbiddenException(string? message) : base(message)
    {
    }

}