namespace api.Models;

public class ImageRecord
{
    public int Id { get; set; }
    public byte[] ImageData { get; set; } // VARBINARY in SQL Server
    public DateTime UploadDate { get; set; }
}
