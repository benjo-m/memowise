﻿namespace api.DTO;

public class DeckCreateRequest
{
    public string Name { get; set; }
    public List<CardDto> Cards { get; set; }
}
