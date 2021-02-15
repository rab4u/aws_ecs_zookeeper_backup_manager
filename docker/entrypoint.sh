#!/bin/bash

# CREATE LOG FILE
touch ./s3_backup.log

# ENABLE AUTO BACKUP UPON CONTAINER START
if [ "$AUTO_BACKUP_ENABLED" = "true" ]
then
  echo "[INFO] AWS BACKUP SERVICE STARTING ...."
  nohup ./aws_s3_bkup_service.sh > ./s3_backup.log 2>&1 &
  echo "[INFO] AWS BACKUP SERVICE STARTED WITH PID $!"
  nohup python3 ./zookeeper_bkup_metrics.py 2>&1 &
  echo "[INFO] AWS BACKUP METRICS SERVER STARTED WITH PID $!"
else
  echo "[INFO] AWS BACKUP SERVICE IS DISABLED"
fi

# PREVENT CONTAINER TERMINATION
tail -f ./s3_backup.log