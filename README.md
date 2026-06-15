# deploy_agent_taiwodotunx1

# Script Summary
A shell script that automates the creation of a Student Attendance Tracker workspace,
configures settings through the command line, and handles system signals gracefully.

# Here's how to run the script
1. You first have to clone the repository
2. Move into the directory using: cd deploy_agent_taiwodotunx1
3. Run the script using :bash setup_project.sh
4. Follow the prompts on command line:
    Enter a project name
    Choose if you want to update attendance thresholds
    Enter new Warning and Failure threshold values if you do

# How to trigger the archive feature
The archive feature is triggered by pressing **Ctrl+C** at any point during script execution.

When it is triggered:
1. The script catches the interrupt signal (SIGINT)
2. Bundles the incomplete project directory into a `.tar.gz` archive
3. Deletes the incomplete directory
4. Exits
