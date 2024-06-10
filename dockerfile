# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy the project file into the container
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the files into the container
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app .

EXPOSE 8080
 
# Set the entry point for the application
ENTRYPOINT ["dotnet", "Web-App-DevOps.dll"]
