#!/bin/bash
#############################################################################################
# Stop Applicatons of  Student Spaces in PCF Instance
#
#  This script will stop all apps in  spaces for a target org based from an input list
#  of email addresses.  The email address list compose existing PCF logins, and
#  the list will be used to name the designated students space.
#
# Usage:
#  stop-student-apps.sh <FILE NAME> <ORG NAME>
#
# Where:
#  <FILE NAME> file name of list of emails delimited by newline
#  <ORG NAME>  organization name where spaces exist
#
# Prerequisites:
#  - cf commandline is installed
#  - cf login completed with the Org Manager of the target organization
#  - Each email in the email list file must have associated user already
#    created in PCF instance
#
#############################################################################################


if [ -z "$1" ] || [ -z "$2"  ]; then
  echo  Usage:  $0 \<FILE NAME\> \<ORG NAME\>
  echo  Where:
  echo  " <FILE NAME> file name of list of emails delimited by newline"
  echo  " <ORG NAME>  organization name where spaces will be created in PCF instance"
  exit
fi

filename=$1

org=$2
org_guid=$(cf org $org --guid)
echo "INFO: guid for $org is $org_guid"

user=$(cf target |grep User |cut -c 17-)

for email in $(cat $filename) ; do

  # switch target 
  cf target -o $org -s $email
  apps=$(cf apps | grep 'cfapps.io' | tr -s ' '  | cut -d' ' -f1 )
  for app in $apps; do
    cf stop $app
  done
done
