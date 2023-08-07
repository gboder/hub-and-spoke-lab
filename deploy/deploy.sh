# declare an array of strings
RESOURCE_GROUP=rg-hubandspoke-hub-lab
RESOURCE_GROUPS=($RESOURCE_GROUP "rg-hubandspoke-spoke-devvms-lab" "rg-hubandspoke-spoke-app-lab")

# iterate over the array elements
for i in "${RESOURCE_GROUPS[@]}"
do
  az group delete --name $i --yes
  az group create --name $i --location switzerlandnorth
done

az deployment group validate --resource-group $RESOURCE_GROUP --template-file main.bicep
az deployment group what-if --resource-group $RESOURCE_GROUP --template-file main.bicep
az deployment group create --resource-group $RESOURCE_GROUP --template-file main.bicep --name main_$RANDOM