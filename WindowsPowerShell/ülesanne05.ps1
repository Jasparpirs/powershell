Clear-Host
$hostName = (Get-ComputerInfo).CsName
Write-Output $hostName
Write-Output "*******************"
$ipAddress = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -ne 'WellKnown' }).IPAddress
Write-Output $ipAddress
Write-Output "*******************"
$ram = (Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB -as [int]
Write-Output "$ram GB"
Write-Output "*******************"


$cpuName = (Get-CimInstance -ClassName Win32_Processor).Name
Write-Output $cpuName
Write-Output "*******************"


$gpuName = (Get-CimInstance -ClassName Win32_VideoController).Name
Write-Output $gpuName
Write-Output "*******************"


$userAccounts = (Get-CimInstance -ClassName Win32_UserAccount).Name
$userAccounts | ForEach-Object { Write-Output $_ }
Write-Output "*******************"

Read-Host "Vajuta Enter, et skripti lõpetada"
