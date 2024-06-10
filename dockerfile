# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /source

# Copy the project file into the container
COPY *.csproj ./
RUN dotnet restore
#not rrunning
# Copy the rest of the files into the container
COPY . ./

# Build the application
RUN dotnet publish -c Release --property:PublishDir=/app/out  # Output directory should be /app/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /source  # Change the working directory to /source

# Copy the published output from the build stage into the runtime image
COPY --from=build /app/out ./

EXPOSE 3000

# Set the entry point for the application
ENTRYPOINT ["dotnet", "Web-App-DevOps.dll"]
