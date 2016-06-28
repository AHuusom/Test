Select-AzureSubscription -SubscriptionName "GKIT-Prod"
$cloudservicename = "GreveK-DC"
$name = "dc-a01"
$vm = get-azurevm -ServiceName $cloudservicename -name $name
$winRMCert = ($vm | select -ExpandProperty vm).DefaultWinRMCertificateThumbprint

if (!$winRMCert)
{
    write-Host ("**ERROR**: Unable to find WinRM Certificate for virtual machine '"+$virtualMachineName)
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $virtualMachineName
    if (!$vm)
    {
        write-Host ("virtual machine "+$virtualMachineName+" not found in cloud service "+$cloudServiceName);
    }
    Exit
}

$AzureX509cert = Get-AzureCertificate -ServiceName $cloudServiceName -Thumbprint $winRMCert -ThumbprintAlgorithm sha1

$certTempFile = [IO.Path]::GetTempFileName()
$AzureX509cert.Data | Out-File $certTempFile

