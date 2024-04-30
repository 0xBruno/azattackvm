#!/usr/bin/env bash

# build ARM template for Deploy with Azure button
az bicep build --file main.bicep --outfile azuredeploy.json
az bicep build-params --file azattack.bicepparam