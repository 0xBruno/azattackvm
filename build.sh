#!/usr/bin/env bash

# build ARM template for Deploy with Azure button
az bicep build --file azattack.bicep --outfile azuredeploy.json
az bicep build-params --file azattack.bicepparam --outfile azuredeploy.params.json