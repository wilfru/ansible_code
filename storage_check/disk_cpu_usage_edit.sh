#!/bin/sh
expected_diskusage="264"
expected_dbconn="25"
expected_httpdconn="20"
expected_cpuusage="95"
#expected_fd="100"
httpdconn=$(ps -ef | grep -i httpd | grep -v grep | wc -l) 
#httpd connections
cpu_usage=$(ps aux | awk 'NR > 0 { s += $3 }; END {print s}')
disk_usage=$(df -h | awk '{print $2}' | head -n3 | awk 'NF {s=$0} END {print s}')
#db_connections=$(mysql -uroot -pexxxxxx -s -N -e "show processlist" | wc -l)
db_connections=6
cld_alert() { 
        nwconn=$1    
	cpu_usage=$2    
	disk_usage=$3    
	db_connections=$4    
	message=$5    
	touch /tmp/alert.txt && > /tmp/alert.txt    
	date=$(date)    
	echo -e "$date\n" > /tmp/alert.txt    
	echo -e "$message" >> /tmp/alert.txt    
	path="/proc/$httpd/fd/"    
	cd $path    
	tfd=$(ls -l | wc -l)    
	sfd=$(ls -ltr | grep sock | wc -l)    
	echo "Total fds: $tfd" >> /tmp/alert.txt    
	echo "Socket fds: $sfd" >> /tmp/alert.txt    
	echo "Other fds: $((tfd - sfd))" >> /tmp/alert.txt
        freememory=$(vmstat | awk '{if (NR == 3) print "Free Memory:" $4}')    
        echo "Free memory : $freememory" >> /tmp/alert.txt    
	Bufferedmemory=$(vmstat | awk '{if (NR == 3) print "Buffered Memory:" $5}')    
	echo "Buffered memory : $Bufferedmemory" >> /tmp/alert.txt    
	CacheMemory=$(vmstat | awk '{if (NR == 3) print "Cache Memory:" $6}')    
	echo "Cache memory : $CacheMemory" >> /tmp/alert.txt    
	sshconn=$(netstat -an | grep 22 | wc -l)  
	#ssh connections    
	httpsconn=$(netstat -an | grep 443 | wc -l)  
	#https connections    
	wwwconn=$(netstat -an | grep 80 | wc -l)  
	#www connections    
	echo "Disk usage is $disk_usage" >> /tmp/alert.txt    
	echo "DB connections $db_connections" >> /tmp/alert.txt    
	echo "Network connections $nwconn" >> /tmp/alert.txt    
	echo "CPU Usage: $cpu_usage" >> /tmp/alert.txt    
	topsnapshot=$(top -n 1 -b)    
	echo "===========================TOP COMMAND SNAPSHOT====================================================" >> /tmp/alert.txt    
	echo "$topsnapshot" >> /tmp/alert.txt    
	echo "==================PS COMMAND SNAPSHOT==============================================================" >> /tmp/alert.txt    
	entireprocesslist=$(ps -ef)    
	echo "$entireprocesslist" >> /tmp/alert.txt
        echo Hello hi ""
}
#message=""
    if [ "${disk_usage%?}" -le "$expected_diskusage" ]; 
then    
    #echo "disk usage exceeded"
   # else    
        echo "$message Disk usage limit exceeded Current disk usage is $disk_usage Configured disk usage is $expected_diskusage"  
    fi
        # Checking for CPU usage    
	#if [ "$cpu_usage" -ge "$expected_cpuusage" ]; 
        #then        
         #   echo "CPU usage exceeded"        
	  #  if [ -n "$message" ]; 
           # then            
       #      message="$message\n\nCPU usage exceeded configured usage limit \nCurrent CPU usage is $cpu_usage\nConfigured CPU usage is $expected_cpuusage\n\n\n\n\n"        
            #else            
                  # message="CPU usage exceeded configured usage limit \nCurrent CPU usage is $cpu_usage\nConfigured CPU usage is $expected_cpuusage\n\n\n\n\n"        
	    #fi    
	#fi
#fi
