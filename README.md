# Hub and Spoke Lab

This repository contains some Azure BICEP files to deploy an Hub & Spoke network topologies with.

- An Hub with nothing else than a KeyVault and the Hub Network
- An App Spoke where an AppService is deployed
- A Dev-VMs Spoke where DEV VMs are deployed - those have public access enabled.

# Execution

1. Check the names and values within the `deploy.sh` and `main.bicep` files.
2. Run, using Az CLI, the `deploy.sh` script.