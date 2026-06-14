#!/bin/bash

# The Signal Trap
cleanup() {
    echo " Interrupt detected! Cleaning up..."
    if [ -d "$PARENT_DIR" ]; then
        tar -czf "attendance_tracker_${input}_archive.tar.gz" "$PARENT_DIR"
        rm -rf "$PARENT_DIR"
        echo "Done! Archive created and directory deleted."
    else
        echo "Nothing to archive. Exiting cleanly."
    fi
    exit 1
}

trap cleanup SIGINT

# Phase 1 - Getting the user input
echo "This is the Attendance Tracker Project Setup"
read -p "Provide your project name " input

# Creating the Directories with the user's input
PARENT_DIR="attendance_tracker_$input"

if [ -d "$PARENT_DIR" ]; then
	echo "The directory $PARENT_DIR already exists"
	exit 1
fi

mkdir -p "$PARENT_DIR/Helpers"
mkdir -p "$PARENT_DIR/reports"

# Moving the files into correct locations
cp attendance_checker.py "$PARENT_DIR"
cp assets.csv "$PARENT_DIR/Helpers/"
cp config.json "$PARENT_DIR/Helpers/"
cp reports.log "$PARENT_DIR/reports"

echo "Directory structure is successfully created"

# Phase 2 - Dynamic Configuration (Stream Editing)
read -p "Do you want to update the Attendance Thresholds ? (Yes/No): " update_decision
if [ "${update_decision,,}" = "yes" ]; then
	read -p "Provide new Warning Threshold (default 75): " warning
	read -p "Provide new Failure Threshold (default 50): " failure

# Just incase the user doesn't input anything
if [ "$warning" = "" ]; then
	warning=75
fi
if [ "$failure" = "" ]; then
	failure=50
fi

# if user also inputs anything other than numbers
if ! [[ "$warning" =~ ^[0-9]+$ ]]; then
    echo "Invalid! Enter number only, Using default 75."
    warning=75
fi

if ! [[ "$failure" =~ ^[0-9]+$ ]]; then
    echo "Invalid! Enter number only, Using default 50."
    failure=50
fi

# Using the sed command to edit the json file and reflect the new values

sed -i "s/\"warning\": [0-9]*/\"warning\": $warning/" "$PARENT_DIR/Helpers/config.json"
sed -i "s/\"failure\": [0-9]*/\"failure\": $failure/" "$PARENT_DIR/Helpers/config.json"

echo "Thresholds has been updated — Warning: $warning%, Failure: $failure%"
else
echo "Making use of default thresholds — Warning: 75%, Failure: 50%"
fi

#  Environment Validation
echo "Running Health Check..."

# Check python3
python3 --version && echo "Python3 found!" || echo "WARNING: Python3 not installed!"

# Verify directory structure
echo "Verifying directory structure..."

if [ -f "$PARENT_DIR/attendance_checker.py" ] && \
   [ -f "$PARENT_DIR/Helpers/assets.csv" ] && \
   [ -f "$PARENT_DIR/Helpers/config.json" ] && \
   [ -f "$PARENT_DIR/reports/reports.log" ]; then
    echo "Directory structure verified successfully!"
else
    echo "WARNING: Some files are missing from the structure!"
fi


