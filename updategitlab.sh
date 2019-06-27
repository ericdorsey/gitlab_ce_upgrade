#!/bin/bash

# Usage:
# If script is run without an argument it attempts to install whatever the latest gitlab-ce it finds
# If script is run with an arugment it attempts to install the version supplied (as the first argument)

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Exiting. This script must be run as root"
   exit 1
fi

echo "INSTRUCTIONS:"
echo "If receive message 'It is recommended to upgrade to the last minor version in a major version series firste before jumping to the next major version'"
echo "Find version number with:"
echo "# apt list --all-versions gitlab-ce | head -n 20"
echo "Install that version"
echo "# apt-get install gitlab-ce=version_number_here"
echo ""

# Example "next major version" message
#gitlab preinstall: It seems you are upgrading from 11.x version series
#gitlab preinstall: to 12.x series. It is recommended to upgrade
#gitlab preinstall: to the last minor version in a major version series first before
#gitlab preinstall: jumping to the next major version.
#gitlab preinstall: Please follow the upgrade documentation at https://docs.gitlab.com/ee/policy/maintenance.html#upgrade-recommendations
#gitlab preinstall: and upgrade to 11.11 first.

# Get the date
mydate=$(date +'%Y-%m-%d_%H-%M-%S')

# Create the filename
filename="${mydate}_gitlabupgrade.log"

# Create outputlog dir if it doesn't exist
outputlogdir="/root/scripts/updategitlab/outputlog/"
mkdir -p $outputlogdir

# Create fullfilename
fullfilename=$outputlogdir$filename

# Output Current Env. & Version Info to the Log File
echo "Running gitlab-rake gitlab:env:info" 2>&1 | tee -a $fullfilename
gitlab-rake gitlab:env:info 2>&1 | tee -a $fullfilename

# Check if arguments passed to script was zero
if [ "$#" -eq "0" ]
then
    # Make a backup of gitlab before upgrading
    echo ""
    echo "Running gitlab-rake gitlab:backup:create STRATEGY=copy && apt-get update && apt-get install gitlab-ce" 2>&1 | tee -a $fullfilename
    gitlab-rake gitlab:backup:create STRATEGY=copy && apt-get update && apt-get install gitlab-ce 2>&1 | tee -a $fullfilename
else
    # Upgrade to the version number passed as the first argument
    echo ""
    echo "Running gitlab-rake gitlab:backup:create STRATEGY=copy && apt-get update && apt-get install gitlab-ce=$1" 2>&1 | tee -a $fullfilename
    gitlab-rake gitlab:backup:create STRATEGY=copy && apt-get update && apt-get install gitlab-ce=$1 | tee -a $fullfilename
fi
