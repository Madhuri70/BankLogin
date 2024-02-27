FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Web_BankLogin/Web_BankLogin.csproj", "Web_BankLogin/"]
RUN dotnet restore "./Web_BankLogin/./Web_BankLogin.csproj"
COPY . .
WORKDIR "/src/Web_BankLogin"
RUN dotnet build "./Web_BankLogin.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Web_BankLogin.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Web_BankLogin.dll"]
