Import-Module ActiveDirectory

$path = "F:\skriptid\powershell\windowspowershell" Get-ChildItem -Path $path -Filter "*.ps1" -Recurse | Select-Object FullName

$inactiveOU = "OU=INAKTIIVSED KASUTAJAD,DC=PIRS,DC=LOCAL"
$Aasta = (Get-Date).AddYears(-1)

$users = Get-ADUser -Filter * -Properties LastLogonDate

foreach ($user in $users) {
    if ($user.LastLogonDate -eq $null -or $user.LastLogonDate -lt $oneYearAgo) {
        Move-ADObject -Identity $user.DistinguishedName -TargetPath $inactiveOU
        Disable-ADAccount -Identity $user.SamAccountName
        Write-Output "Kasutaja $($user.SamAccountName) on liigutatud ja deaktiveeritud."
    }
}