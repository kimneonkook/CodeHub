# Multisoft Cloud Infrastructure Project

![Azure](https://img.shields.io/badge/Azure-0089D6?logo=microsoft-azure&logoColor=white)
![.NET](https://img.shields.io/badge/.NET-512BD4?logo=dotnet&logoColor=white)
![Bicep](https://img.shields.io/badge/Bicep-3399FF?logo=microsoft-azure&logoColor=white)

## Project Overview
Implementation of a cloud-native API infrastructure for MultiSoftware Enterprise on Microsoft Azure, fulfilling Requirement #4 (Public API Hosting) from the project assignment.

## Key Components
- **API Host**: ASP.NET Core 6 Web API
- **Infrastructure**: Azure App Service + API Management
- **CI/CD**: GitHub Actions (optional)
- **Monitoring**: Azure Application Insights

## Repository Structure


## Deployment Steps

### Prerequisites
- Azure CLI
- .NET 6 SDK
- Bicep CLI

### 1. Infrastructure Deployment
```bash
az deployment group create \
  --resource-group MultiSoft-API-RG \
  --template-file infra/api.bicep
  cd src/Multisoft.API
./scripts/deploy.sh