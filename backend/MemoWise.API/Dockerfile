FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY MemoWise.Model ./MemoWise.Model

COPY MemoWise.API ./MemoWise.API

RUN dotnet restore MemoWise.API/MemoWise.API.csproj

RUN dotnet publish MemoWise.API/MemoWise.API.csproj -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .

EXPOSE 8080

ENTRYPOINT ["dotnet", "MemoWise.API.dll"]
