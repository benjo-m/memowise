using api.Data;
using api.Services;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

FirebaseApp.Create(new AppOptions()
{
    Credential = GoogleCredential.GetApplicationDefault(),
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("MemoWiseDb")));
builder.Services.Configure<RouteOptions>(options => options.LowercaseUrls = true);
builder.Services.AddScoped<UserService>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
