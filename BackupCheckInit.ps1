# Expected hash of main script file. This must be updated manually after an update.




# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE

# Variables

$updateNeeded = ""





# Functions

function scriptDownload { 
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/MITKY-Jason/WindowsBackupChecker-Public/main/WindowsBackupChecker.ps1 -outfile C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
}


function generateHash {
    param (
        OptionalParameters
    )
    
}

function compareHash {
    param (
        OptionalParameters
    )
    
}


function scriptRun {
    param (
        OptionalParameters
    )
    
}


# Hash the main script file and compare it to the expected hash listed above.
# If it matches, simply run the script and nothing else.
# If it does not match, prompt the user to update the script.

generateHash

compareHash




# Switch the update flag and move on to the next section.
# Rename the main script file.




# Download the main script file and wait a few seconds.
scriptDownload




# Hash the downloaded file, then compare it to the expected hash listed above.
# If it matches, run the script. If not, report an error and prompt to try again.

compareHash

scriptRun

