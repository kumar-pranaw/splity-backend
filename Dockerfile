# --- Build Stage ---
    FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
    WORKDIR /src
    
    # Correct paths based on folder structure
    COPY Splity/Splity.API/Splity.API.csproj Splity.API/
    COPY Splity/Splity.Application/Splity.Application.csproj Splity.Application/
    COPY Splity/Splity.Domain/Splity.Domain.csproj Splity.Domain/
    COPY Splity/Splity.Infrastructure/Splity.Infrastructure.csproj Splity.Infrastructure/
    COPY Splity/Splity.Persistence/Splity.Persistence.csproj Splity.Persistence/
    
    RUN dotnet restore Splity.API/Splity.API.csproj
    
    COPY . .
    WORKDIR /src/Splity/Splity.API
    RUN dotnet publish -c Release -o /app/publish
    
    # --- Runtime Stage ---
    FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
    WORKDIR /app
    COPY --from=build /app/publish .
    EXPOSE 80
    ENTRYPOINT ["dotnet", "Splity.API.dll"]
    