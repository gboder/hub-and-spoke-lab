#!/bin/bash
random_number=$RANDOM
current_date=$(date +%Y-%m-%d)
tag_suffix="${random_number}-${current_date}"

# Publish the api
dotnet publish ../../src/api/api.csproj -c Release -o ../../src/api/publish

# Build the image
docker build -t api:latest -t acrgbolabshub001.azurecr.io/hubspokelab/api:latest --platform linux/amd64 ../../src/api
docker build -t rp:latest -t acrgbolabshub001.azurecr.io/hubspokelab/rp:latest --platform linux/amd64 ../../src/rp

# Azure Container Registry login
az acr login --name acrgbolabshub001

# Push the image
docker push acrgbolabshub001.azurecr.io/hubspokelab/api:latest
docker push acrgbolabshub001.azurecr.io/hubspokelab/rp:latest