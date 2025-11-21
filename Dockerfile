# ========== BUILD STAGE ==========
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY . .

WORKDIR /src/Presentation/Nop.Web
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# ========== RUNTIME STAGE ==========
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

# Heroku will set $PORT, we don't hard-code it here
EXPOSE 8080

ENTRYPOINT ["dotnet", "Nop.Web.dll"]

