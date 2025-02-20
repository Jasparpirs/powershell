$csvFail = "F:\Skriptid\powershell\WindowsPowerShell\AD_Kasutajad.csv"
$domeen = "pirs.local"  
$vaikeParool = "Passw0rd!"
$juurOU = "OU=KASUTAJAD,DC=pirs,DC=local" 

# Impordi CSV fail
try {
    $kasutajad = Import-Csv -Path $csvFail 
}
catch {
    Write-Error "Viga CSV faili importimisel: $($_.Exception.Message)"
    exit
}


function Loo-OU {
    param (
        [string]$OUName,
        [string]$ParentOU
    )
    try {
        New-ADOrganizationalUnit -Name $OUName -Path $ParentOU -ProtectedFromAccidentalDeletion $false
        Write-Host "Loodud OU: $OUName asukohas $ParentOU" -ForegroundColor Green
    }
    catch {
        Write-Warning "Viga OU loomisel  $($_.Exception.Message)"
    }
}


foreach ($kasutaja in $kasutajad) {
    
    $eesnimi = $kasutaja.eesnimi
    $perenimi = $kasutaja.perenimi
    $osakond = $kasutaja.osakond

   
    if (-not $eesnimi -or -not $perenimi -or -not $osakond) {
        Write-Warning "andmed puuduvad "
        continue
    }

    $OUName = $osakond
    $OUPath = "OU=$OUName,$juurOU"

    
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -SearchBase $juurOU)) {
        Loo-OU -OUName $OUName -ParentOU $juurOU
    } else {
        Write-Host "OU $OUName on juba olemas."
    }

    $kasutajanimi = "$eesnimi.$perenimi"
    $email = "$($eesnimi.Substring(0,1))$perenimi@$domeen"

    if (Get-ADUser -Filter "SamAccountName -eq '$kasutajanimi'") {
        Write-Warning "Kasutaja $kasutajanimi on juba olemas. Jäetakse vahele."
        continue
    }

   
    try {
        $parool = ConvertTo-SecureString $vaikeParool -AsPlainText -Force
        New-ADUser -SamAccountName $kasutajanimi -UserPrincipalName $email -Name "$eesnimi $perenimi" -GivenName $eesnimi -Surname $perenimi -Path $OUPath -AccountPassword $parool -Enabled $true -ChangePasswordAtLogon $true

        
        Set-ADUser -Identity $kasutajanimi -EmailAddress $email

        Write-Host "Kasutaja $kasutajanimi on loodud." -ForegroundColor Green
    }
    catch {
        Write-Warning "Viga kasutaja $kasutajanimi loomisel: $($_.Exception.Message)"
    }
}

Write-Host "Skript on lõpetatud." -ForegroundColor Yellow