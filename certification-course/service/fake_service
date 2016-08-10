#!/bin/bash
# fake_service
# Starts up, writes to a dummy file, and exits
#
# chkconfig: 35 69 31
# description: This service doesn't do anything.
# Source function library

. /etc/sysconfig/fake_service

case "$1" in
 start) echo "Running fake_service in start mode..."
   touch /var/lock/subsys/fake_service
   echo "$0 start at $(date)" >> /var/log/fake_service.log
   if [ ${VAR1} = "true" ]
   then
     echo "VAR1 set to true" >> /var/log/fake_service.log
   fi
   echo
   ;;
 stop)
  echo "Running the fake_service script in stop mode..."
  echo "$0 stop at $(date)" >> /var/log/fake_service.log
  if [ ${VAR2} = "true" ]
  then
      echo "VAR2 = true" >> /var/log/fake_service.log
  fi
  rm -f /var/lock/subsys/fake_service
  echo
  ;;
*)
  echo "Usage: fake_service {start | stop}"
  exit 1
esac
exit 0
