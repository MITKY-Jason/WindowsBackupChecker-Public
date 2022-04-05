# Expected hash of main script file. This must be updated manually after an update.


# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE

# Variables


# Functions


# Hash the main script file and compare it to the expected hash listed above.
# If it matches, simply run the script and nothing else.
# If it does not match, prompt the user to update the script.


# Switch the update flag and move on to the next section.
# Rename the main script file.


# Download the main script file and wait a few seconds.

Invoke-WebRequest -Uri https://raw.githubusercontent.com/MITKY-Jason/WindowsBackupChecker-Public/main/WindowsBackupChecker.ps1 -outfile C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
# Test File will output a message only.

# Hash the downloaded file, then compare it to the expected hash listed above.
# If it matches, run the script. If not, report an error and prompt to try again.

. C:\Backup_the_backups\WindowsBackupChecker\WindowsBackupChecker.ps1
