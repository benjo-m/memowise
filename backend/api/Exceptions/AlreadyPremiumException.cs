namespace api.Exceptions;

public class AlreadyPremiumException : Exception
{
    public AlreadyPremiumException(string message)
        : base(message) 
    {
    }
}
