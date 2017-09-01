#!/bin/bash
#############################################################################################
# Delete Student Spaces in PCF Instance
#
#  This script will delete spaces for a target org based from an input list
#  of email addresses.  The email address list compose existing PCF logins, and
#  the list will be used to name the designated students space.
#
# Usage:
#  delete-student-spaces.sh <FILE NAME> <ORG NAME>
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

org_guid=$(cf org $org --guid)
echo "INFO: guid for $org is $org_guid"

user=$(cf target |grep User |cut -c 17-)

for email in $(cat $filename) ; do

  # This is necessary in case the user running the script does not have
  # SpaceDeveloper role to each of the spaces that are to be cleaned up.
  echo "INFO: Assigning $user SpaceDeveloper role for space $email"
  cf set-space-role $user $org $email SpaceDeveloper

  # TODO This looks suspiciously Lab specific, need more investigation to generic-size
  # Attempt to delete the service instance for the MongoDB service broker.
  # Note we are making an assumption on the service name here, if the student
  # used any other name this will obviously fail.
  echo "INFO: Attempting to force deletion of the mongo-service service instance"
  cf purge-service-instance mongo-service -f
  
  # Delete the space
  space_guid=$(cf space $email --guid)
	echo "INFO: Deleting space: $email ($space_guid)"
  cf curl "/v2/spaces/$space_guid?recursive=true" -X DELETE

  # Remove the user from the organization
  echo "INFO: Removing $email user from $org"
  cf curl "/v2/organizations/$org_guid/users" -X DELETE -d "{\"username\": \"$email\"}"

done
