#!/usr/bin/env bash
echo "[INFO] ZOOKEEPER BACKUP SERVICE RUNNING SUCCESSFULLY"

backup_metrics()
{
  local backup_status=$1
  local backup_time=$2
  echo "# ZOOKEEPER BACKUP METRICS" > ./zookeeper_backup.metrics
  echo "zookeeper_backup_status{error=\"1\",ok=\"0\"} $backup_status" >> ./zookeeper_backup.metrics
  echo "zookeeper_latest_backup_time{error=\"0\",ok=\"timestamp\"} $backup_time" >> ./zookeeper_backup.metrics
}

datetime=$(date +%s)

while true
do
  # MIRROR THE ZOOKEEPER SERVERS
  # mirror /some/path json://!home!user!backup.json/  async verbose skip_prompt
  zk-shell "$ZOO_SERVERS" --run-once 'mirror / json://!zookeeper-backup.json/ false false true'
  if [ $? -ne 0 ];then
    # backup_status=1 (error) backup_time=0 (error)
    backup_metrics 1 0
    datetime=$(date +%s)
  else
    # COPY THE BACKUP TO S3
    datetime=$(date +%s)
    aws s3 cp zookeeper-backup.json s3://"$S3_PATH/$BACKUP_NAME/$datetime/"
    if [ $? -ne 0 ];then
      # backup_status=1 (error) backup_time=0 (error)
      backup_metrics 1 0
    else
        # backup_status=0 (ok) backup_time=6252735272 (ok)
        backup_metrics 0 $(date +%s)
    fi
  fi

  #  LOG ROTATION
  count=$(wc -l ./s3_backup.log | awk '{ print $1 }')
  if [ $count -ge 100 ]
  then
    tail -n 100 ./s3_backup.log | sponge ./s3_backup.log
  fi

  sleep "$BACKUP_INTERVAL"

done
