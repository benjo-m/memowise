namespace api.Exceptions;

public class DeckLimitException : Exception
{
    public DeckLimitException(string message) 
        : base(message) 
    { 
    }
}
