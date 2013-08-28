#!/bin/bash

#################
TEACHER_IP="1.1.1.1"
#user,password same as teacher
USER="student"
PASSWORD="student"
################

expect_func(){
               expect << EOF
                set timeout 1000
                spawn $1
                expect {
                 "Password:" { send "$PASSWORD\r";exp_continue}
                }
EOF
}

expect_func "ssh $USER@10.7.201.221"
