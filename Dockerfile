# ========== BUILD STAGE ==========
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# copy everything into the container
COPY . .

# go to Nop.Web project
WORKDIR /src/Presentation/Nop.Web

# restore & publish
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# ========== RUNTIME STAGE ==========
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

# Kestrel listens on 5000 inside the container
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "Nop.Web.dll"]
