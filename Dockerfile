FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app 
#
# copy csproj and restore as distinct layers
COPY *.sln .
COPY MenuApp.ApiGateway/*.csproj ./MenuApp.ApiGateway/
#
RUN dotnet restore 
#
# copy everything else and build app
COPY MenuApp.ApiGateway/. ./MenuApp.ApiGateway/
#
WORKDIR /app/MenuApp.ApiGateway
RUN dotnet publish -c Release -o out 
#
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app 
#
COPY --from=build /app/MenuApp.ApiGateway/out ./

EXPOSE 80
ENTRYPOINT ["dotnet", "MenuApp.ApiGateway.dll"]