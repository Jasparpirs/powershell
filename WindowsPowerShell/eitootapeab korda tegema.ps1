# Määra CSV faili asukoht
$csvPath = "AD_Kasutajad.csv"

# Määra juur-OU, mille alla uued OU-d luuakse
$kasutajadOU = "OU=KASUTAJAD,DC=pirs,DC=local"

# Määra vaikimisi parool
$defaultPassword = "Passw0rd"

# Impordi CSV fail
try {
    $users = Import-Csv -Path "F:\Skriptid\powershell\WindowsPowerShell\AD_Kasutajad.csv"
}
catch {
    Write-Error "CSV faili importimisel tekkis viga: $($_.Exception.Message)"
    exit
}

# Kontrolli kas 'Active Directory' moodul on saadaval
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Warning "Active Directory moodul pole saadaval. Proovin importida."
    try {
        Import-Module ActiveDirectory
    }
    catch {
        Write-Error "Active Directory mooduli importimisel tekkis viga: $($_.Exception.Message)"
        exit
    }
}

# Käi läbi iga kasutaja CSV failis
foreach ($user in $users) {
    # Võta kasutaja andmed
    $eesnimi = $user.Eesnimi
    $perenimi = $user.Perenimi
    $ouNimi = $user.OU
    $kasutajanimi = "$eesnimi.$perenimi"
    $email = "$($eesnimi.Substring(0,1))$perenimi@perenimi.local"
    $userOU = "OU=$ouNimi,$kasutajadOU"

    Write-Host "Processing user: $kasutajanimi"

    # Kontrolli kas OU on olemas
    if (!(Get-ADOrganizationalUnit -Identity $userOU -ErrorAction SilentlyContinue)) {
        Write-Host "OU '$ouNimi' ei eksisteeri. Loome uue OU."
        try {
            New-ADOrganizationalUnit -Name $ouNimi -Path $kasutajadOU
            Write-Host "OU '$ouNimi' loodud edukalt."
        }
        catch {
            Write-Error "OU loomisel tekkis viga: $($_.Exception.Message)"
            continue # Jätka järgmise kasutajaga
        }
    } else {
        Write-Host "OU '$ouNimi' on juba olemas."
    }

    # Kontrolli kas kasutaja on juba olemas
    if (Get-ADUser -Identity $kasutajanimi -ErrorAction SilentlyContinue) {
        Write-Warning "Kasutaja '$kasutajanimi' on juba olemas. Jätan vahele."
        continue # Jätka järgmise kasutajaga
    }

    # Loo kasutaja
    Write-Host "Loome kasutaja '$kasutajanimi'."
    try {
        # Teisenda parool turvaliseks stringiks
        $securePassword = ConvertTo-SecureString $defaultPassword -AsPlainText -Force

        # Loo kasutaja AD-sse
        $userParams = @{
            SamAccountName   = $kasutajanimi
            UserPrincipalName = $email
            GivenName         = $eesnimi
            Surname           = $perenimi
            DisplayName       = "$eesnimi $perenimi"
            Path              = $userOU
            AccountPassword   = $securePassword
            Enabled           = $true
            ChangePasswordAtLogon = $true #Kasutaja peab parooli vahetama esimesel sisselogimisel
        }
        New-ADUser @userParams

        #Seadista e-posti aadress
        Set-ADUser -Identity $kasutajanimi -EmailAddress $email

        Write-Host "Kasutaja '$kasutajanimi' loodud edukalt."
    }
    catch {
        Write-Error "Kasutaja loomisel tekkis viga: $($_.Exception.Message)"
    }
}

Write-Host "Skript lõpetatud."