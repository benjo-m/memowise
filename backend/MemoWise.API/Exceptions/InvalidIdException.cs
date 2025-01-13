namespace api.Exceptions
{
    public class InvalidIdException : Exception
    {
        public string ErrorCode { get; set; }

        public InvalidIdException(string errorCode, string message) 
            : base(message)  
        {
            ErrorCode = errorCode;
        }
    }
}
