# THIS FILE MUST BE UPDATED MANUALLY. DO NOT UPDATE DIRECTLY FROM GITHUB!

# Expected hash of main script file. This must be updated manually after an update.

$currentScriptHash = "1A2471E5941D5A1366402F95C483FDAEFB9EA3BAFCD5FA268A1C23C67D4E606D"
$currentStyleHash = "B16B3C1797FEF794FEEC62EDF89BC25FC072E72C11B54FDEF6D111EA5744122B"

# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE

# Hash the main script file and style.css file and compare them to the expected hash listed above.
# If they match, simply run the script and nothing else.
# If they do not match, prompt the user to update the script.

$scriptHashResult = Get-FileHash C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1 -Algorithm SHA256
$scriptHash = $scriptHashResult.Hash

$styleHashResult = Get-FileHash C:\Backup_the_backups\WindowsBackupChecker\style.css -Algorithm SHA256
$styleHash = $styleHashResult.Hash

if (($scriptHash -ne $currentScriptHash) -or ($styleHash -ne $currentStyleHash)) {
    # do nothing - move on without running script
} 
else {
    . C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
    Write-Host "DONE!"
    Exit 
}

# Test that the temp folder exists and create it if necessary.

if (!(Test-Path "$env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\"))
{
	New-Item -path "$env:HOMEPATH\APPDATA\Local\Temp\" -Name "WindowsBackupChecker" -ItemType "directory"
	Write-Host "Created temp folder"
}
else {Write-Host "Temp folder already exists"}

# Download the main script file and wait a few seconds.

Invoke-WebRequest -Uri https://raw.githubusercontent.com/MITKY-Jason/WindowsBackupChecker-Public/main/WindowsBackupChecker.ps1 -outfile $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\WindowsBackupChecker.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MITKY-Jason/WindowsBackupChecker-Public/main/style.css -outfile $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\style.css

# Hash the downloaded files, then compare them to the expected hashes listed above.
# If they match, run the script. If not, report an error and prompt to check the expected hashes.

$newScriptHashResult = Get-FileHash $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\WindowsBackupChecker.ps1 -Algorithm SHA256
$newScriptHash = $newScriptHashResult.Hash

$newStyleHashResult = Get-FileHash $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\style.css -Algorithm SHA256
$newStyleHash = $newStyleHashResult.Hash

if (($newScriptHash -ne $currentScriptHash) -or ($newStyleHash -ne $currentStyleHash)) {
    Write-Error "File may be compromised! Hashes do not match! Check that the current hash variable in this script is the correct version."
    Exit
} 
else {
    . C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
    Write-Host "DONE!"
    Exit 
}
