#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Exiting. This script must be run as root"
   exit 1
fi

# Get the date
mydate=$(date +'%Y-%m-%d_%H-%M-%S')

# Create the filename
filename="${mydate}_gitlabupgrade.log"

# Create outputlog dir if it doesn't exist
outputlogdir="/root/scripts/updategitlab/outputlog/"
mkdir -p $outputlogdir

# Create fullfilename
fullfilename=$outputlogdir$filename

# Make a backup of gitlab before upgrading
gitlab-rake gitlab:backup:create STRATEGY=copy && apt-get update && apt-get install gitlab-ce 2>&1 | tee $fullfilename
