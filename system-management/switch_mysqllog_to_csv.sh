#!/bin/bash
echo "time|user|ip|query_time|lock_time|rows_sent|rows_examined|timestamp|sql" >> $2
nawk 'BEGIN{OFS="|"}
/# Time:/{
	time=$3" "$4
	getline
        if ($3 ~ "pamc")
		user="pamc"
        else if ( $3 ~ "webadmin")
    		user="webadmin"
        ip = substr($5,2,length($5)-2)
        getline
     	query_time = $3
	lock_time = $5
        rows_sent = $7
        rows_examined = $9
        getline
        timestamp = substr($2,11,length($2)-11)
	getline
        sql = $0
	print time, user,ip,query_time,lock_time,rows_sent,rows_examined,timestamp,sql
}' $1 >> $2
