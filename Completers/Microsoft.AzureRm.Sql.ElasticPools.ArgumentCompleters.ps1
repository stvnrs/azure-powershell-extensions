$ScriptBlock = {
        <#
        .SYNOPSIS
        Auto-complete the -ElasticPoolName parameter value for Azure Automation Runbook Azure Resource Manager (ARM) PowerShell cmdlets.
		
		NOTE: Use this command to find commands that this auto-completer applies to: 
		(Get-Command -Module AzureRM.Sql -Name *Sql* -ParameterName ElasticPoolName).ForEach({ "'{0}'" -f $PSItem.Name }) | Set-Clipboard

        .NOTES
		Created by Steven Rose @stvnrs based on a template by Trevor Sullivan <trevor@trevorsullivan.net>
        
        #>
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

        try {
			$Params = @{
				ResourceType='Microsoft.Sql/servers/ElasticPools';
			}

			if($wordToComplete)
			{
				$Params.Add('ResourceNameContains',$wordToComplete)
			}

			if($fakeBoundParameter["ResourceGroupName"]) {
				$Params.Add('ResourceGroupName', $fakeBoundParameter["ResourceGroupName"])
			}

			$ObjectList = Find-AzureRmResource @Params -ErrorAction Stop -WarningAction Ignore;

			if($fakeBoundParameter["ServerName"]) {
				$ObjectList = $ObjectList | Where-Object {$_.ResourceName.StartsWith($fakeBoundParameter["ServerName"])}
			}

        } catch {
            Write-Host -Object ('Error occurred retrieving Sql Servers: {0}' -f $PSItem.Exception.Message);
        }

        $ItemList = $ObjectList  | ForEach-Object {
            $CompletionText = $PSItem.ResourceName.Split('/')[1];
            $ToolTip = 'Database {0} on {1} in {2} Resource Group.' -f $PSItem.ResourceName.Split('/')[1], $PSItem.ResourceName.Split('/')[0], $PSItem.ResourceGroupName;
            $ListItemText = '{0}' -f $PSItem.ResourceName.Split('/')[1];
            $CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue;

            New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($CompletionText, $ListItemText, $CompletionResultType, $ToolTip);
        }

        return $ItemList
    }

$ArgumentCompleter = @{
        CommandName = @(
			'Get-AzureRmSqlDatabaseActivity'
			'Get-AzureRmSqlElasticPool'
			'Get-AzureRmSqlElasticPoolActivity'
			'Get-AzureRmSqlElasticPoolDatabase'
			'New-AzureRmSqlDatabase'
			'New-AzureRmSqlDatabaseCopy'
			'New-AzureRmSqlElasticPool'
			'Remove-AzureRmSqlElasticPool'
			'Set-AzureRmSqlDatabase'
			'Set-AzureRmSqlElasticPool'
		);

        ParameterName = 'ElasticPoolName';
        ScriptBlock = $ScriptBlock;
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter @ArgumentCompleter;
