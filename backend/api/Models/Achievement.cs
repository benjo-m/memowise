﻿using System.Text.Json.Serialization;

namespace api.Models;

public class Achievement
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string Icon { get; set; }
    [JsonIgnore]
    public List<User> Users { get; set; } = [];
}
