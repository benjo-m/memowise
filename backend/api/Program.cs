using api.Data;
using api.ML;
using api.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
    });
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new OpenApiSecurityScheme()
    {
        Type = SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });
});
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("MemoWiseDb")));
builder.Services.Configure<RouteOptions>(options => options.LowercaseUrls = true);
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<DeckService>();
builder.Services.AddScoped<CardService>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<RegressionModel>();
builder.Services.AddScoped<StudySessionService>();
builder.Services.AddScoped<AchievementsService>();
builder.Services.AddScoped<SeedDataService>();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var seedDataService = scope.ServiceProvider.GetRequiredService<SeedDataService>();
    seedDataService.PopulateDatabase();
}


if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
