# Cloud Infrastructure Project - MultiSoftware Enterprise

## Project Overview
This project implements a cloud-native environment on Microsoft Azure with secure, scalable infrastructure supporting application development, data storage, and centralized management.

## Functional Requirements

### 1. Authentication & Authorization
- Azure Entra ID for identity management
- Multi-factor authentication (MFA) enforcement
- Role-based access control (RBAC)

### 2. Web Hosting
- ASP.NET Core website (1000 visitors/day)
- Azure App Service (Standard S1 tier)

### 3. Data Storage
| Service | Purpose | Capacity |
|---------|---------|----------|
| Azure SQL Database | Structured data | 2000 reads/500 writes daily |
| Azure Blob Storage | Unstructured data | Automatic backups |

### 4. API Hosting
- Public API (5000 requests/day)
- Azure API Management (Developer tier)

### 5. Serverless Operations
- Azure Functions (Python/HTTP triggers)

## Deployment

### Prerequisites
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)

### Deployment Commands
```bash
# Authenticate
az login

# Deploy resources
az deployment group create \
  --resource-group <your-resource-group> \
  --template-file "./infra/main.bicep" \
  --parameters "./infra/params.json"

## Team
- [Efstratia Voskou]  
- [Zoi Iliadou]  
- [Morfeo Alcani] 
- [Ioannis Mylonakis] 

**University of Thessaly**  
**April 2025**  