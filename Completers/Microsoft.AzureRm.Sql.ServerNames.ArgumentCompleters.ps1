$ScriptBlock = {
        <#
        .SYNOPSIS
        Auto-complete the -ServerName parameter value for Azure Automation Runbook Azure Resource Manager (ARM) PowerShell cmdlets.
		
		NOTE: Use this command to find commands that this auto-completer applies to: 
		(Get-Command -Module AzureRM.Sql -Name *Sql* -ParameterName ServerName).ForEach({ "'{0}'" -f $PSItem.Name }) | Set-Clipboard

        .NOTES
		Created by Steven Rose @stvnrs based on a template by Trevor Sullivan <trevor@trevorsullivan.net>
        
        #>
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

        try {
			$Params = @{ResourceType='Microsoft.Sql/servers'}

			if($fakeBoundParameter["ResourceGroupName"]) {
				$Params.Add('ResourceGroupName', $fakeBoundParameter["ResourceGroupName"])
			}

			$ObjectList = Find-AzureRmResource @Params -ErrorAction Stop -WarningAction Ignore;
        } catch {
            Write-Host -Object ('Error occurred retrieving Sql Servers: {0}' -f $PSItem.Exception.Message);
        }

        $ItemList = $ObjectList | Where-Object { $PSItem.Name -match $wordToComplete } | ForEach-Object {
            $CompletionText = $PSItem.ResourceName;
            $ToolTip = 'Sql Server {0} in {1} Resource Group Account.' -f $PSItem.ResourceName, $PSItem.ResourceGroupName;
            $ListItemText = '{0}' -f $PSItem.ResourceName;
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
			'Get-AzureRmSqlDatabaseServerAuditingPolicy'
			'Get-AzureRmSqlDatabaseThreatDetectionPolicy'
			'Get-AzureRmSqlDatabaseTransparentDataEncryption'
			'Get-AzureRmSqlDatabaseTransparentDataEncryptionActivity'
			'Get-AzureRmSqlDatabaseUpgradeHint'
			'Get-AzureRmSqlElasticPool'
			'Get-AzureRmSqlElasticPoolActivity'
			'Get-AzureRmSqlElasticPoolDatabase'
			'Get-AzureRmSqlElasticPoolRecommendation'
			'Get-AzureRmSqlServer'
			'Get-AzureRmSqlServerActiveDirectoryAdministrator'
			'Get-AzureRmSqlServerAuditingPolicy'
			'Get-AzureRmSqlServerCommunicationLink'
			'Get-AzureRmSqlServerFirewallRule'
			'Get-AzureRmSqlServerServiceObjective'
			'Get-AzureRmSqlServerUpgrade'
			'Get-AzureRmSqlServerUpgradeHint'
			'New-AzureRmSqlDatabase'
			'New-AzureRmSqlDatabaseCopy'
			'New-AzureRmSqlDatabaseDataMaskingRule'
			'New-AzureRmSqlDatabaseSecondary'
			'New-AzureRmSqlElasticPool'
			'New-AzureRmSqlServer'
			'New-AzureRmSqlServerCommunicationLink'
			'New-AzureRmSqlServerFirewallRule'
			'Remove-AzureRmSqlDatabase'
			'Remove-AzureRmSqlDatabaseAuditing'
			'Remove-AzureRmSqlDatabaseDataMaskingRule'
			'Remove-AzureRmSqlDatabaseSecondary'
			'Remove-AzureRmSqlDatabaseServerAuditing'
			'Remove-AzureRmSqlDatabaseThreatDetectionPolicy'
			'Remove-AzureRmSqlElasticPool'
			'Remove-AzureRmSqlServer'
			'Remove-AzureRmSqlServerActiveDirectoryAdministrator'
			'Remove-AzureRmSqlServerAuditing'
			'Remove-AzureRmSqlServerCommunicationLink'
			'Remove-AzureRmSqlServerFirewallRule'
			'Resume-AzureRmSqlDatabase'
			'Set-AzureRmSqlDatabase'
			'Set-AzureRmSqlDatabaseAuditingPolicy'
			'Set-AzureRmSqlDatabaseDataMaskingPolicy'
			'Set-AzureRmSqlDatabaseDataMaskingRule'
			'Set-AzureRmSqlDatabaseSecondary'
			'Set-AzureRmSqlDatabaseServerAuditingPolicy'
			'Set-AzureRmSqlDatabaseThreatDetectionPolicy'
			'Set-AzureRmSqlDatabaseTransparentDataEncryption'
			'Set-AzureRmSqlElasticPool'
			'Set-AzureRmSqlServer'
			'Set-AzureRmSqlServerActiveDirectoryAdministrator'
			'Set-AzureRmSqlServerAuditingPolicy'
			'Set-AzureRmSqlServerCommunicationLink'
			'Set-AzureRmSqlServerFirewallRule'
			'Start-AzureRmSqlDatabaseExecuteIndexRecommendation'
			'Start-AzureRmSqlServerUpgrade'
			'Stop-AzureRmSqlDatabaseExecuteIndexRecommendation'
			'Stop-AzureRmSqlServerUpgrade'
			'Suspend-AzureRmSqlDatabase'
			'Use-AzureRmSqlDatabaseServerAuditingPolicy'
			'Use-AzureRmSqlServerAuditingPolicy'
		);

        ParameterName = 'ServerName';
        ScriptBlock = $ScriptBlock;
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter @ArgumentCompleter;
