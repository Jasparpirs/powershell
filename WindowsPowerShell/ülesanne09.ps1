$users = Import-Csv -Path "F:\Skriptid\powershell\WindowsPowerShell\users.csv"

function Genereeri-Parool {
    param (
        [string]$Perenimi
    )
    $random = Get-Random -Minimum 10 -Maximum 99
    $parool = ($Perenimi.Substring(0,3).ToLower() + $random)
    return $parool
}


$results = @()

foreach ($user in $users) {
    
    $nimi = "$($user.first_name) $($user.last_name)"
    $kasutajanimi = "$($user.first_name.Substring(0,1).ToLower())$($user.last_name.ToLower())"
    $email = "$($user.first_name.ToLower()).$($user.last_name.ToLower())@hkhk.edu.ee"
    $parool = Genereeri-Parool -Perenimi $user.last_name

    
    $result = [PSCustomObject]@{
        email = $user.email
        nimi = $nimi
        kasutajanimi = $kasutajanimi
        parool = $parool
    }
    $results += $result
}

$results | Export-Csv -Path "uus_users1.csv" -NoTypeInformation