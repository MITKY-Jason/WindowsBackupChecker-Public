# THIS FILE MUST BE UPDATED MANUALLY. DO NOT UPDATE DIRECTLY FROM GITHUB!

# Expected hash of main script file.

$currentScriptHash = ""
$currentStyleHash = ""

# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE

# Hash the main script file and style.css file and compare them to the expected hash listed above.
# If they match, simply run the script and nothing else.
# If they do not match, prompt the user to update the script.

$scriptHashResult = Get-FileHash C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1 -Algorithm SHA256
$currentScriptHash = $scriptHashResult.Hash

$styleHashResult = Get-FileHash C:\Backup_the_backups\WindowsBackupChecker\style.css -Algorithm SHA256
$currentStyleHash = $styleHashResult.Hash

# if (($scriptHash -ne $currentScriptHash) -or ($styleHash -ne $currentStyleHash)) {
    # do nothing - move on without running script
#} 
# else {
#    . C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
#    Write-Host "DONE!"
#    Exit 
#}

# Test that the temp folder exists and create it if necessary.

if (!(Test-Path "$env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\"))
{
	New-Item -path "$env:HOMEPATH\APPDATA\Local\Temp\" -Name "WindowsBackupChecker" -ItemType "directory"
	Write-Host "Created temp folder"
}
else {Write-Host "Temp folder already exists"}

# Download the main script file and wait a few seconds.

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MITKY-Jason/WindowsBackupChecker-Public/main/WindowsBackupChecker.ps1 -outfile $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\WindowsBackupChecker.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MITKY-Jason/WindowsBackupChecker-Public/main/style.css -outfile $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\style.css

Write-Host "Checking for updates..."
Start-Sleep 10

# Hash the downloaded files, then compare them to the expected hashes listed above.
# If they match, copy the files to the Backup_the_backups folder. If not, report an error and prompt to check the expected hashes.

$newScriptHashResult = Get-FileHash $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\WindowsBackupChecker.ps1 -Algorithm SHA256
$newScriptHash = $newScriptHashResult.Hash

$newStyleHashResult = Get-FileHash $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\style.css -Algorithm SHA256
$newStyleHash = $newStyleHashResult.Hash

if (($newScriptHash -ne $currentScriptHash) -or ($newStyleHash -ne $currentStyleHash)) {
    Move-Item -path $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\WindowsBackupChecker.ps1 -destination C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1 -Force
    Move-Item -path $env:HOMEPATH\APPDATA\Local\Temp\WindowsBackupChecker\style.css -destination C:\Backup_the_backups\WindowsBackupChecker\style.css -Force
    Write-Host "Updated scripts successfully."
} 
else {
    Write-Host "Script is already latest version."
}

# Scripts have updated and hashes match, so run the script

. C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
Write-Host "DONE!"
Exit 