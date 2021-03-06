$ArgumentCompleter = @{
    ### Refresh this list of commands, using this command:
    ### (Get-Command -ParameterName ResourceType).Name.ForEach({ "'{0}'," -f $PSItem }) | Set-Clipboard
    CommandName = @(
        'Find-AzureRmResource',
        'Get-AzureRmResource',
        'Get-AzureRmResourceLock',
        'Get-AzureRmRoleAssignment',
        'Invoke-AzureRmResourceAction',
        'New-AzureRmResource',
        'New-AzureRmResourceLock',
        'New-AzureRmRoleAssignment',
        'Remove-AzureRmResource',
        'Remove-AzureRmResourceLock',
        'Remove-AzureRmRoleAssignment',
        'Set-AzureRmResource',
        'Set-AzureRmResourceLock'
    );
    ParameterName = 'ResourceType';
    ScriptBlock = {
        <#
        .SYNOPSIS
        Auto-complete the -ResourceType parameter value for Azure Resource Manager (ARM) cmdlets.
    
        .NOTES
        Created by Trevor Sullivan <trevor@trevorsullivan.net>
        http://trevorsullivan.net
        http://twitter.com/pcgeek86
        #>
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

        ### Helper function to find an authoritative list of all Azure Resource Manager (ARM) Resource Types
        function Get-AllARMResourceTypes {
            [CmdletBinding()]
            param ( )
            $ResourceProviderList = Get-AzureRmResourceProvider -ListAvailable -WarningAction Ignore;

            foreach ($ResourceProvider in $ResourceProviderList) {
                foreach ($ResourceType in $ResourceProvider.ResourceTypes) {
                    '{0}/{1}' -f $ResourceProvider.ProviderNamespace, $ResourceType.ResourceTypeName;
                }
            }
        }

        ### Create fresh completion results for Azure virtual machines
        $ItemList = Get-AllARMResourceTypes | Where-Object { $PSItem -match $wordToComplete } | ForEach-Object {
            $CompletionText = '{0}' -f $PSItem;
            $ToolTip = '{0}' -f $PSItem;
            $ListItemText = '{0}' -f $PSItem;
            $CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue;

            New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($CompletionText, $ListItemText, $CompletionResultType, $ToolTip);
        }
    
        ### Return the completion results
        return $ItemList;
    }
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter @ArgumentCompleter;