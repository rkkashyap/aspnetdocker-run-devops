#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
# added file
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["dockerwebtest.csproj", "."]
RUN dotnet restore "./dockerwebtest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dockerwebtest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerwebtest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerwebtest.dll"]