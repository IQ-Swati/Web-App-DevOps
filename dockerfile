# Use the official .NET Core runtime as the base image
FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app
# Use the official .NET Core SDK as the build image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Web-App-DevOps.csproj", "./"]
RUN dotnet restore "./Web-App-DevOps.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "Web-App-DevOps.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "Web-App-DevOps.csproj" -c Release -o /app/publish
# Build the final image using the base image and the published output
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Web-App-DevOps.dll"]

