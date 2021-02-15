#!/bin/bash

echo "[INFO] ZOOKEEPER BACKUP RESTORE SERVICE"
echo "[IMP] This script should be run with caution. It will override the current zookeeper node with the backup"
echo -n "Do you want to proceed (y/n)? "
read -r answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Please enter the backup time to restore:"
    read -r datetime
    aws s3 cp "s3://$S3_PATH/$BACKUP_NAME/$datetime/zookeeper-backup.json" ./zookeeper-backup-restore.json
    if [ $? -ne 0 ];then
        echo "[ERROR] ZOOKEEPER BACKUP RESTORE SERVICE FAILED"
    else
        jq 'del(."/zookeeper/config")' zookeeper-backup-restore.json > zookeeper-backup-filtered.json
        if [ $? -ne 0 ];then
            echo "[ERROR] ZOOKEEPER BACKUP RESTORE SERVICE FAILED"
        else
            zk-shell "$ZOO_SERVERS" --run-once 'cp json://!zookeeper-backup-filtered.json/ / true true true true'
            if [ $? -ne 0 ];then
              echo "[ERROR] ZOOKEEPER BACKUP RESTORE SERVICE FAILED"
            else
               echo "[INFO] ZOOKEEPER BACKUP RESTORE SERVICE SUCCESSFUL"
            fi
        fi
    fi
else
    echo "[INFO] No, it is a wise choice. try next time"
fi