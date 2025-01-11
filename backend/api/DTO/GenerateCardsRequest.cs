﻿using System.ComponentModel.DataAnnotations;

namespace api.DTO;

public class GenerateCardsRequest
{
    [Required]
    [MaxLength(100)]
    public string Topic { get; set; }
    [Required]
    [Range(1, 30)]
    public int CardCount { get; set; }
}
