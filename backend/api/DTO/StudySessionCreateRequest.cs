﻿namespace api.DTO;

public class StudySessionCreateRequest
{
    public int UserId { get; set; }
    public int Duration { get; set; }
    public int CardCount { get; set; }
    public float AverageEaseFactor { get; set; }
    public float AverageRepetitions { get; set; }
    public DateTime StudiedAt { get; set; }
}
