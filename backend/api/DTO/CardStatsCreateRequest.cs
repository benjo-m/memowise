﻿namespace api.DTO;

public class CardStatsCreateRequest
{
    public int CardId { get; set; }
    public float EaseFactor { get; set; }
    public int Interval { get; set; }
    public int Repetitions { get; set; }
    public DateTime DueDate { get; set; }
}
