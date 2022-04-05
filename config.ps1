# DO NOT UPDATE THIS FILE FROM GITHUB! IT IS STORED THERE AS A TEMPLATE 
# ONLY AND MUST BE UPDATED FOR EACH SERVER INDIVIDUALLY.

# Test Variable
$testVar = "Test Successful"

# Miscellaneous Variables
$header = get-content "C:\Backup_the_Backups\WindowsBackupChecker\style.css"
$serverName = $env:COMPUTERNAME
[array] $vmList = (Get-WBVirtualMachine).VMName

# Drive letters
$osDrive = "C:"
$hyperVDrive = ""
$winBupDriveLetter = (Get-WBSummary).LastBackupTarget
$extBupDriveLetter = ""
$clearVSSfromDrives = $osDrive, $hyperVDrive, $winBupDriveLetter, $extBupDriveLetter, ""

# Scheduled Tasks
$exbupTaskName = ""
$bupthebupsTask = ""