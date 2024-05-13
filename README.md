## Deploying Infrastructure

### Prerequisites
1. An Azure account with an active subscription.
2. Azure CLI, 2.4 or later.
3. Sign in to Azure by using the `az login` command.

### Deploy the main.bicep template using PowerShell & Azure CLI
```azurecli
  $rgname='TestRG'
  az group create --name $rgname --location eastus
  az deployment group create --resource-group $rgname --template-file ./infra/main.bicep
```

## Deploying Azure Function

### Prerequisites
1. Azure Functions Core Tools v4.x

### Deploy the function project to Azure using PowerShell & Azure Functions Core Tools
```console
cd src
$appname=$(az deployment group show -g $rgname -n main --query properties.parameters.appName.value).replace("`"","")
func azure functionapp publish $appname --dotnet-isolated
```