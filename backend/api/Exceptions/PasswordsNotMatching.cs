namespace api.Exceptions;

public class PasswordsNotMatching : Exception
{
    public PasswordsNotMatching(string message) 
        : base(message)
    {
        
    }
}
