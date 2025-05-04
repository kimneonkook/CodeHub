#!/bin/bash

# Deploy infrastructure
az deployment group create \
  --resource-group "MultiSoft-API-RG" \
  --template-file api.bicep

# Deploy API code
cd src
az webapp up \
  --name "multisoft-webapi" \
  --resource-group "MultiSoft-API-RG" \
  --plan "multisoft-api-plan" \
  --runtime "DOTNETCORE:6.0"