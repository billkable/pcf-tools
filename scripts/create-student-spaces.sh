#!/bin/bash
#############################################################################################
# Create Student Spaces in PCF Instance
#
#  This script will create spaces for a target org based from an input list
#  of email addresses.  The email address list compose existing PCF logins, and
#  the list will be used to name the designated students space.  Each student's
#  space will be set with a specified quota to restrict usage. 
#  The script will also add the user to the org, assuming it exists (see
#  prerequisites.
#
# Usage:
#  create-student-spaces.sh <FILE NAME> <ORG NAME>
#
# Where:
#  <FILE NAME> file name of list of emails delimited by newline
#  <ORG NAME>  organization name where spaces will be created in PCF instance
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
quota=student-5G

echo "INFO: Creating Quota " $quota
cf create-space-quota $quota -i 1G -m 5G -r 20 -s 10 -a 20

org_guid=$(cf org $org --guid)
echo "INFO: guid for $org is $org_guid"

for email in $(cat $filename) ; do

	echo "INFO: Creating space: $email"
	( set -x; cf create-space $email -o $org )

	( set -x; cf curl "/v2/organizations/$org_guid/users" -X PUT -d "{\"username\": \"$email\"}" )

	( set -x; cf set-space-role $email $org $email SpaceDeveloper )
	( set -x; cf set-space-quota $email $quota )

done
