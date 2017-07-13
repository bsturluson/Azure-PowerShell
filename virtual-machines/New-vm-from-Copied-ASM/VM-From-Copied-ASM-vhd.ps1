#Creates a new VM based on an existing vhd which previously has been copied from an ASM VM.

$rgName = "SomeRGName"
$location = "West Europe"

$vnetName="SomeVNet"
$subnetIndex=0
$vnet=Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

$nicName="vm-name-NIC"
$staticIP="10.0.0.6"
$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Location $location -AllocationMethod Static
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id -PrivateIpAddress $staticIP

$vmSize = "Standard_A2"
$osDiskName = $vmName + "OSDisk"
$vmName = "vm-name"

$vm = New-AzureRMVMConfig -VMName $vmName -VMSize $vmSize
$vm = Add-AzureRMVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri = "https://thestorageaccountname.blob.core.windows.net/vhds/the-vhd-disk-name.vhd"
$vm = Set-AzureRMVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption attach -Windows

New-AzureRMVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose
