namespace api.Exceptions;

public class DuplicateEntryException : Exception
{
    public string ErrorCode { get; set; }

    public DuplicateEntryException(string errorCode, string message) 
        : base(message)
    {
        ErrorCode = errorCode;
    }

}
