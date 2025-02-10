$FullName = "Jaspar pirs"

$Email = "jaspar@hkhk.edu.ee"

$TodayDate = Get-Date

# Väljasta kõik muutujad
Write-Output "Täisnimi: $FullName"
Write-Output "Email: $Email"
Write-Output "Tänane kuupäev: $TodayDate"


$skriptiAsukoht = $MyInvocation.MyCommand.Path
$dir = Split-Path $skriptiAsukoht
$emailFilePath = Join-Path -Path $dir -ChildPath "emailid.txt"


$emailContent = Get-Content -Path $emailFilePath


$emailArray = $emailContent -split ','


$myEmail = "jaspar@hkhk.edu.ee"
$emailArray += $myEmail


$emailCount = $emailArray.Length
Write-Output "Emaili massiivis on $emailCount emaili."

$firstEmail = $emailArray[0]
$lastEmail = $emailArray[-1]
Write-Output "first email massiivis: $firstEmail"
Write-Output "last email massiivis: $lastEmail"