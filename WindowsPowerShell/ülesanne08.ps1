
 function Ringi-Pindala {
    param (
        [float]$Raadius
    )

    if ($Raadius -le 0) {
        Write-Host "Raadius peab olema suurem kui 0."
        return
    }

    $Pindala = [math]::PI * $Raadius * $Raadius
    return $Pindala
}

$raadius = Read-Host "Palun sisestage ringi raadius"

if ($raadius -as [float]) {
    $pindala = Ringi-Pindala -Raadius $raadius
    Write-Host "Ringi pindala raadiusega $raadius on $pindala."
} else {
    Write-Host "Palun sisestage kehtiv number raadiuse jaoks."
}

function Puhasta-Taisnimi {
    param (
        [string]$Taisnimi
    )

    $puhastatudNimi = $Taisnimi -replace 'ä', 'a' `
                                  -replace 'ö', 'o' `
                                  -replace 'õ', 'o' `
                                  -replace 'ü', 'y'

    $puhastatudNimi = $puhastatudNimi -replace '[^\p{L} ]', '' 
    $puhastatudNimi = $puhastatudNimi -replace '\s+', ' '     
    $puhastatudNimi = $puhastatudNimi.Trim()                  

    $puhastatudNimi = -join ($puhastatudNimi -split ' ' | ForEach-Object { 
        if ($_ -ne '') { 
            $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower() 
        }
    })

    return $puhastatudNimi
}

$nimeSisend = Read-Host " sisestage oma täisnimi)"

$puhastatudNimi = Puhasta-Taisnimi -Taisnimi $nimeSisend
Write-Host "Puhastatud nimi: $puhastatudNimi"
