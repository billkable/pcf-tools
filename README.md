# pcf-tools
## Overview
This project is a place holder for PCF instructor tools, located in the ./scripts directory.  The initial scope provides following capabilities:
1. Create set of student workspaces in a given instructor owned organization.  Commonly used to prepare/stage a course require student use of PCF.
2. Stop all student apps in a given instructor owned organization.
3. Drop all student workspaces in a given instructor owned organization.  Commonly used after completion of a course.

## Usage
### Prerequisites
Following conditions must be met before executing the PCF tools
1. cf CLI tools must be installed from workstation executing scripts.
2. Org Manager must be logged into PCF instance (i.e. cf login) targeting the destination Org.
3. The user list file must contain email addresses of user accounts already set up in the target PCF instance

### Create Student Spaces

    create-student-spaces.sh <FILE NAME> <ORG NAME>

  Where:
    <FILE NAME> file name of list of emails delimited by newline (example in ./data/user.list)
    <ORG NAME>  organization name where spaces will be created in PCF instance

### Stop Student Applications

    stop-student-apps.sh <FILE NAME> <ORG NAME>

  Where:
    <FILE NAME> file name of list of emails delimited by newline (example in ./data/user.list)
    <ORG NAME>  organization name where spaces will be created in PCF instance
      
### Drop Student Applications

    delete-student-spaces.sh <FILE NAME> <ORG NAME>

  Where:
    <FILE NAME> file name of list of emails delimited by newline (example in ./data/user.list)
    <ORG NAME>  organization name where spaces will be created in PCF instance
