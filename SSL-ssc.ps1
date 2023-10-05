# Specifica il percorso di openssl.exe se non è già nel tuo PATH
$opensslPath = "c:\Apache24\bin\openssl.exe" # Modifica con il tuo percorso

# Verifica che OpenSSL sia disponibile
if (-not (Test-Path $opensslPath)) {
    Write-Error "OpenSSL non è stato trovato nel percorso specificato."
    exit
}

# Chiedi conferma dei parametri
$country = Read-Host "Inserisci il Codice del Paese (es: IT)"
$state = Read-Host "Inserisci il Nome dello Stato o Provincia"
$locality = Read-Host "Inserisci il Nome della Località"
$organization = Read-Host "Inserisci il Nome dell'Organizzazione"
$organizationalUnit = Read-Host "Inserisci il Nome dell'Unità Organizzativa"
$commonName = Read-Host "Inserisci il Nome Comune (es: example.com)"
$emailAddress = Read-Host "Inserisci l'Indirizzo Email"
$days = Read-Host "Per quanti giorni il certificato dovrebbe essere valido?"

# Genera la chiave privata
& $opensslPath genpkey -algorithm RSA -out privatekey.pem

# Genera il certificato
$subject = "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalUnit/CN=$commonName/emailAddress=$emailAddress"
& $opensslPath req -new -x509 -key privatekey.pem -out certificate.pem -days $days -subj $subject

Write-Output "Certificato generato con successo!"
