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

## Cost Analysis

### 5-Year Total Cost Comparison
| Cost Component       | On-Premises | Azure  |
|----------------------|-------------|--------|
| **Compute**          | $28,697     | $7,068 |
| **Hardware**         | $3,368      | $0     |
| **Software**         | $7,694      | $0     |
| **Database**         | $16,727     | $4,156 |
| **Storage**          | $467        | $0     |
| **IT Labor**         | $2,300      | $0     |
| **Total**            | **$36,404** | **$11,224** |

**Total Savings**: $25,180 over 5 years

![Detailed Cost Breakdown](./Estimated%20billing/Cost.png)

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

```
### Team
- [Efstratia Voskou]  
- [Zoi Iliadou]  
- [Morfeo Alcani] 
- [Ioannis Mylonakis] 

**University of Thessaly**  
**April 2025**  