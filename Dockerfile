FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . .
WORKDIR /src/Presentation/Nop.Web
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
# bind to Heroku port
CMD ASPNETCORE_URLS=http://*:$PORT dotnet Nop.Web.dll

COPY --from=build /app/publish ./
