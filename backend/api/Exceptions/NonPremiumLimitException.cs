namespace api.Exceptions;

public class NonPremiumLimitException : Exception
{
    public NonPremiumLimitException(string message) 
        : base(message) 
    { 
    }
}
