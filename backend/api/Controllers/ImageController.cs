using api.Data;
using api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace api.Controllers;

[AllowAnonymous]
public class ImageController : BaseController
{
    private readonly ApplicationDbContext _context;

    public ImageController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost("uploadImage")]
    public async Task<IActionResult> UploadImage([FromForm] IFormFile image)
    {
        if (image == null || image.Length == 0)
        {
            return BadRequest("No file uploaded");
        }

        using (var memoryStream = new MemoryStream())
        {
            await image.CopyToAsync(memoryStream);
            byte[] imageBytes = memoryStream.ToArray();

            var imageRecord = new ImageRecord
            {
                ImageData = imageBytes,
                UploadDate = DateTime.Now
            };

            _context.ImageRecords.Add(imageRecord);
            await _context.SaveChangesAsync();

            return Ok("Image uploaded successfully");
        }
    }

    [HttpGet("getImage/{id}")]
    public async Task<IActionResult> GetImage(int id)
    {
        var imageRecord = await _context.ImageRecords
            .Where(i => i.Id == id)
            .FirstOrDefaultAsync();

        if (imageRecord == null)
        {
            return NotFound("Image not found.");
        }

        // Return the image as a byte array
        return File(imageRecord.ImageData, "image/jpeg");  // Adjust MIME type if needed
    }

}
