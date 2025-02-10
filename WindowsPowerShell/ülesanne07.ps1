$ComputerName = (Get-WmiObject -Class Win32_ComputerSystem).Name
Write-Output "PC name: $ComputerName"

$LogicalDisks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
$DiskCount = $LogicalDisks.Count
Write-Output "Arvutis on $DiskCount loogilist ketast."


foreach ($disk in $LogicalDisks) {
    $FreeSpace = $disk.FreeSpace
    $Size = $disk.Size
    $FreeSpacePercentage = [math]::round(($FreeSpace / $Size) * 100, 2)
    Write-Output "Ketas $($disk.DeviceID): $FreeSpacePercentage% vaba ruumi"
    if ($FreeSpacePercentage -lt 50) {
        Write-Output "hakkab tais saama"
    }
}