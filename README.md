# Cloud Infrastructure Project - MultiSoftware Enterprise

## Project Overview
This project involves designing and implementing a fully cloud-native environment for MultiSoftware Enterprise on Microsoft Azure. The goal is to establish a secure, scalable, and resilient infrastructure that supports application development, data storage, global collaboration, and centralized management. The solution leverages Azure services to meet functional requirements such as authentication, hosting, data storage, API management, and monitoring.

## Functional Requirements
1. **Authentication & Authorization**:  
   - Use Azure Entra ID for centralized identity management.  
   - Enforce multi-factor authentication (MFA) for remote access and administrators.  
   - Role-based access control (RBAC) for developers and administrators.  

2. **Web Hosting**:  
   - Host an ASP.NET Core website (~1000 visitors/day) using Azure App Service.  

3. **Data Storage**:  
   - Structured data: Azure SQL Database or Cosmos DB (~2000 reads/500 writes daily).  
   - Unstructured data: Azure Blob Storage (documents, images).  
   - Automatic backups and encryption at rest.  

4. **API Hosting**:  
   - Host a public API (~5000 requests/day, 5 kb/request) using Azure API Management.  

5. **Serverless Operations**:  
   - Implement stateless functions with Azure Functions.  

6. **Content Storage**:  
   - Store public images/videos (~250 GB) in Blob Storage with lifecycle policies.  

7. **Logging & Compliance**:  
   - Archive server logs (~5 TB, +50 GB/month) in Azure Archive Storage.  

8. **Monitoring**:  
   - Enable Azure Monitor, Application Insights, and Log Analytics.  
   - Set alerts for critical metrics (CPU, failures, DB response time).  

9. **Billing**:  
   - Separate billing for project resources.  
 

## Team
- [Efstratia Voskou]  
- [Zoi Iliadou]  
- [Morfeo Alcani] 
- [Giannis Mylonakis] 

**University of Thessaly**  
**April 2025**  