## Deploying Infrastructure

### Prerequisites
1. An Azure account with an active subscription.
2. Azure CLI, 2.4 or later.
3. Sign in to Azure by using the `az login` command.

### Deploy the main.bicep template
```azurecli
  rgname='TestRG'
  az group create --name $rgname --location eastus
  az deployment group create --resource-group $rgname --template-file ./infra/main.bicep
```

## Deploying Azure Function

### Prerequisites
1. Azure Functions Core Tools v4.x

### Deploy the function project to Azure
```console
cd src
appname=$(az deployment group show -g $rgname -n main --query properties.parameters.appName.value)
func azure functionapp publish $appname
```