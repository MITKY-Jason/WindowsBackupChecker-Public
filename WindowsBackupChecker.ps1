# Server-specific variables are imported from the config file
. C:\Backup_the_Backups\WindowsBackupChecker\config.ps1


# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE

# PowerShell commands
Import-Module ScheduledTasks
$pageTitle = "<h1>$serverName : Windows Server Backup and Backup Script Report</h1>"
Write-Host "Gathering information about backups. This may take a few minutes."


# Get information about VM Checkpoints
Write-Host "Checking for checkpoints on virtual machines..."
$vmCheckpoints = Get-VMSnapshot -VMName $vmList
$vmCheckpointsResult = "<p id='GoodText'>Did not find any VM checkpoints.</p>"
if ($null -ne $vmCheckpoints) {$vmCheckpointsResult = $vmCheckpoints | ConvertTo-Html -Property VMName,Name,CreationTime -Fragment}


# Get information from scheduled tasks "Backup the backups" and External Backup Script. CHANGE the TaskName for exbupResult according to the host
Write-Host "Checking scheduled tasks..."
$bupthebupsReport = get-scheduledtaskinfo -TaskName $bupthebupsTask | ConvertTo-Html -As List -Property NextRunTime,LastTaskResult -Fragment
$bupthebupsResult = get-scheduledtaskinfo -TaskName $bupthebupsTask
$bupthebupsSuccess = "<p id='ErrorText'>The task did not run successfully.</p>"
if ($bupthebupsResult.LastTaskResult -eq "0") {
    $bupthebupsSuccess = "<p id='GoodText'>The task ran successfully!</p>"
}

$exbupResult = get-scheduledtaskinfo -TaskName $exbupTaskName | ConvertTo-Html -As List -Property NextRunTime,LastTaskResult -Fragment -PreContent "<h2>External Backup Script</h2>"


# Get information about Windows Server Backup schedule and contents of backup drive.
Write-Host "Checking Windows Server Backup..."
$winBupDriveLetter = (Get-WBSummary).LastBackupTarget
$winBupDrive = Get-WmiObject -Class Win32_logicaldisk -Filter "DeviceID = '$winBupDriveLetter'"
$winBupDriveContents = $winBupDriveLetter | Get-ChildItem
$revisions = (Get-WBSummary).LastBackupTarget | Get-ChildItem | Where-Object {$_.Name -like "*WindowsImageBackup*"}

Write-Host "Checking internal backup drive..."
[array] $revisionSizes = foreach ($rev in $revisions) {Get-ChildItem $winBupDriveLetter\$rev -Recurse | Measure-Object -property length -sum}
$revisionTypicalSize = ($revisionSizes.Sum | Measure-Object -Average)
$revisionTypicalSizeGB = "{0:N2} GB" -f (($revisionSizes.Sum | Measure-Object -Average).Average / 1GB)
$winBupDriveFreeSpace = "{0:N2} GB" -f ($winBupDrive.FreeSpace / 1GB)
$enoughRevisions = $false
if ($revisions.Length -gt 2) {$enoughRevisions = $true}
$spaceforNewRevision = $false
if ($winBupDrive.FreeSpace -gt ($revisionTypicalSize.Average) * 1.6) {$spaceforNewRevision = $true}
$notenoughSpace = $false
if ($winBupDrive.FreeSpace -lt ($revisionTypicalSize.Average) * 0.1) {$notenoughSpace = $true}
$nonBupData = $false
if ($winBupDriveContents.Length -gt $revisions.Length) {$nonBupData = $true}
$winBupRecentFailure = $false
$winBupErrors = Get-WBJob -previous 4 | Where-Object {$_.HResult -ne "0"}
if ($winBupErrors.length -gt 0) {$winBupRecentFailure = $true}


$bupDriveAssessment = ""
# FIRST check for at least three revisions
if (($enoughRevisions -eq $false) -and ($spaceforNewRevision -eq $false)) {
    $bupDriveAssessment = "<p id='Text'>There are less than three revisions, but there is not enough space to add a revision. <br>
    This calculation allows for growth of the backup file by up to 20%.</p>"
    }

if (($enoughRevisions -eq $false) -and ($spaceforNewRevision -eq $true)) {
    $bupDriveAssessment = "<p id='Text'>There are less than three revisions, and there is sufficient space to add a revision. <br>
    This calculation allows for growth of the backup file by up to 20%.</p>"
    }

if (($enoughRevisions -eq $true) -and ($notenoughSpace -eq $false)) {
    $bupDriveAssessment = "<p id='GoodText'>There are at least three revisions. No additional revisions are needed.</p>"
    }

# THEN check if the drive is full
if (($notenoughSpace -eq $true) -and ($nonBupData -eq $true)) {
    $bupDriveAssessment = "<p id='Text'>The drive is getting full. There are additional files on the drive, consider deleting them if they are not needed.</p>"
    }

if (($notenoughSpace -eq $true) -and ($nonBupData -eq $false)) {
$bupDriveAssessment = "<p id='Text'>The drive is getting full. It may be necessary to decrease the number of revisions.</p>"
    }

# THEN check for failed backups because they will cause the revision size estimate to be inaccurate
if  ($winBupRecentFailure -eq $true) {
    $bupDriveAssessment = "<p id='ErrorText'>Cannot assess revisions on backup drive due to recent Windows Server Backup failures. Revision size estimate is probably wrong!</p>"
}

$winBupResult = Get-WBSummary | ConvertTo-Html -As List -Property NextBackupTime,LastBackupResultHR -Fragment
$winBupDriveContentsList = $winBupDriveLetter | Get-ChildItem | ConvertTo-Html -Property FullName, CreationTime -Fragment -PreContent "<h2>Windows Backup Drive Contents</h2>"
$winBupLastCompletionTime = (Get-WBJob -Previous 1).EndTime
$winBupLastBackupResult = (Get-WBJob -Previous 1).HResult
$winBupLastBackupSuccess = "<p id='ErrorText'>The last backup was not successful!</p>"
if ($winBupLastBackupResult -eq "0") {
    $winBupLastBackupSuccess = "<p id='GoodText'>The last backup was successful!</p>"
}

# Get information about external backup drive contents. Enter the drive letter of the external backup drive for the first variable
Write-Host "Checking external backup drive..."
# $extBupDrive = Get-WmiObject -Class Win32_logicaldisk -Filter "DeviceID = '$extBupDriveLetter'"
$extBupDriveContentsList = $extBupDriveLetter | Get-ChildItem | ConvertTo-Html -Property FullName, CreationTime -Fragment -PreContent "<h2>External Backup Drive Contents</h2>"

# Get information about online backups on VMs.

# Generate and save the report as an HTML file
Write-Host "Building Report..."
$BackupReport = ConvertTo-Html -Body "
$pageTitle 
<p id='CreationDate'>Creation Date: $(Get-Date)</p><br> 
<h2>VM Checkpoints</h2>
$vmCheckpointsResult 
<h2>Backup the Backups Script</h2>
$bupthebupsSuccess
$bupthebupsReport
$exbupResult
<h2>Windows Backup Result</h2>
$winBupLastBackupSuccess
<p id='Text'>Windows Backup last completed: $winBupLastCompletionTime </p>
$winBupResult
<h2>Backup Revision Assessment</h2>
$bupDriveAssessment
<p id='Text'>Revisions should be about: $revisionTypicalSizeGB </p>
<p id='Text'>Backup drive free space: $winBupDriveFreeSpace </p>
$winBupDriveContentsList 
$extBupDriveContentsList" -Head $header -Title "$serverName - Windows Backup Report"

$BackupReport | Out-File .\WindowsBackupReport.html

# These next two lines are only here for testing so that errors can be viewed in Powershell. They can be removed for regular use.
# Write-Host "Report ready. Press any key to view."
# $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 

# Open the report
.\WindowsBackupReport.html