namespace api.Exceptions;

public class PasswordsNotMatchingException : Exception
{
    public PasswordsNotMatchingException(string message) 
        : base(message)
    {
        
    }
}
