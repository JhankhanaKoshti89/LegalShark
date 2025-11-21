# ========== BUILD STAGE ==========
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .

WORKDIR /src/Presentation/Nop.Web

RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# ========== RUNTIME STAGE ==========
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Heroku uses $PORT; bind Kestrel to 8080
ENV ASPNETCORE_URLS=http://+:8080

COPY --from=build /app/publish ./

ENTRYPOINT ["dotnet", "Nop.Web.dll"]
