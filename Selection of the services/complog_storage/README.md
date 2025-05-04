## Task 7: Server Log Storage  
### Solution  
- **Secure**: Private endpoint + no public access.  
- **Compliant**: Auto-tier to Cool (30 days), delete after 1 year.  
- **Validation**: See [deployment-output.json](deployment-output.json).  

### Deployment  
```bash  
az deployment group create \  
  --resource-group LogStorageRG \  
  --template-file logStorage.bicep \  
  --parameters retentionDays=365  