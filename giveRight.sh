#! /bin/bash

### Use to add the right to the group for all directory and files for the directory given in argument
### Right: 664 for classical files
###        775 for executable files (.sh; .R; .pl; .py)
###        775 for all directory
### Usage: giveRight.sh <DIRECTORY>

if [ $# -ne 1 ]
then
    echo "Usage: giveRight.sh <DIRECTORY>"
    exit
fi

dir=$1"/"

chmod 775 $dir
find $dir -type f -exec chmod 664 {} \;
find $dir -type f -iname "*.sh" -exec chmod 775 {} \;
find $dir -type f -iname "*.R"  -exec chmod 775 {} \;
find $dir -type f -iname "*.pl" -exec chmod 775 {} \;
find $dir -type f -iname "*.py" -exec chmod 775 {} \;
find $dir -type d -exec chmod 775 {} \;

