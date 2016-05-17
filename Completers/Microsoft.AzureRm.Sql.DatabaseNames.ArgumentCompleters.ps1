$ScriptBlock = {
        <#
        .SYNOPSIS
        Auto-complete the -ServerName parameter value for Azure Automation Runbook Azure Resource Manager (ARM) PowerShell cmdlets.
		
		NOTE: Use this command to find commands that this auto-completer applies to: 
		(Get-Command -Module AzureRM.Sql -Name *Sql* -ParameterName DatabaseName).ForEach({ "'{0}'" -f $PSItem.Name }) | Set-Clipboard

        .NOTES
		Created by Steven Rose @stvnrs based on a template by Trevor Sullivan <trevor@trevorsullivan.net>
        
        #>
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

        try {
			$Params = @{
				ResourceType='Microsoft.Sql/servers/databases';
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

			if('Resume-AzureRmSqlDatabase','Suspend-AzureRmSqlDatabase' -contains $commandName){
				$ObjectList = $ObjectList | Where-Object {$_.Kind -match 'datawarehouse'}
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
			'Get-AzureRmSqlDatabase'
			'Get-AzureRmSqlDatabaseActivity'
			'Get-AzureRmSqlDatabaseAuditingPolicy'
			'Get-AzureRmSqlDatabaseDataMaskingPolicy'
			'Get-AzureRmSqlDatabaseDataMaskingRule'
			'Get-AzureRmSqlDatabaseExpanded'
			'Get-AzureRmSqlDatabaseIndexRecommendations'
			'Get-AzureRmSqlDatabaseReplicationLink'
			'Get-AzureRmSqlDatabaseRestorePoints'
			'Get-AzureRmSqlDatabaseSecureConnectionPolicy'
			'Get-AzureRmSqlDatabaseThreatDetectionPolicy'
			'Get-AzureRmSqlDatabaseTransparentDataEncryption'
			'Get-AzureRmSqlDatabaseTransparentDataEncryptionActivity'
			'Get-AzureRmSqlDatabaseUpgradeHint'
			'Get-AzureRmSqlElasticPoolDatabase'
			'Get-AzureRmSqlServerServiceObjective'
			'New-AzureRmSqlDatabaseCopy'
			'New-AzureRmSqlDatabaseDataMaskingRule'
			'New-AzureRmSqlDatabaseSecondary'
			'Remove-AzureRmSqlDatabase'
			'Remove-AzureRmSqlDatabaseAuditing'
			'Remove-AzureRmSqlDatabaseDataMaskingRule'
			'Remove-AzureRmSqlDatabaseSecondary'
			'Remove-AzureRmSqlDatabaseThreatDetectionPolicy'
			'Resume-AzureRmSqlDatabase'
			'Set-AzureRmSqlDatabase'
			'Set-AzureRmSqlDatabaseAuditingPolicy'
			'Set-AzureRmSqlDatabaseDataMaskingPolicy'
			'Set-AzureRmSqlDatabaseDataMaskingRule'
			'Set-AzureRmSqlDatabaseSecondary'
			'Set-AzureRmSqlDatabaseThreatDetectionPolicy'
			'Set-AzureRmSqlDatabaseTransparentDataEncryption'
			'Start-AzureRmSqlDatabaseExecuteIndexRecommendation'
			'Stop-AzureRmSqlDatabaseExecuteIndexRecommendation'
			'Suspend-AzureRmSqlDatabase'
			'Use-AzureRmSqlDatabaseServerAuditingPolicy'
			'Use-AzureRmSqlServerAuditingPolicy'
		);

        ParameterName = 'DatabaseName';
        ScriptBlock = $ScriptBlock;
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter @ArgumentCompleter;
