FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY MemoWise.Model ./MemoWise.Model

COPY MemoWise.SubscriberEmail ./MemoWise.SubscriberEmail

RUN dotnet restore MemoWise.SubscriberEmail/MemoWise.SubscriberEmail.csproj

RUN dotnet publish MemoWise.SubscriberEmail/MemoWise.SubscriberEmail.csproj -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .

EXPOSE 8080

ENTRYPOINT ["dotnet", "MemoWise.SubscriberEmail.dll"]
