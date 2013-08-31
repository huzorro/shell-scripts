#!/bin/bash
#===============================================================================
#
#          FILE:  read-employees.sh
# 
#         USAGE:  ./read-employees.sh 
# 
#   DESCRIPTION:  read employee.txt field
# 
#       VERSION:  1.0
#       CREATED:  08/31/2013 03:42:29 PM CST
#      REVISION:  ---
#==============================================================================
IFS=:
echo "Employee Names:"
echo "---------------"
cat ./employees.txt | grep -v '^#'| while read name empid dept
do
    echo "$name is part of $dept department"
done
