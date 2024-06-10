# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /source

# Copy the project file(s) and restore any dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code into the container
COPY . ./

# Build the application with detailed verbosity to debug issues
RUN dotnet publish -c Release -o /out --verbosity detailed

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the build output from the build stage to the runtime stage
COPY --from=build /out .

# Expose the port on which the application will be available
EXPOSE 8080

# Set the entry point for the application
ENTRYPOINT ["dotnet", "Web-App-DevOps.dll"]
