RESOURCE_GROUP=rg-hubspokelab-networking-01
# az group delete --name $RESOURCE_GROUP --yes
az group create --name $RESOURCE_GROUP --location switzerlandnorth
az deployment group validate --resource-group $RESOURCE_GROUP --template-file main.bicep
az deployment group what-if --resource-group $RESOURCE_GROUP --template-file main.bicep
az deployment group create --resource-group $RESOURCE_GROUP --template-file main.bicep