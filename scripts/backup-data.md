### etcd minio redis
```bash
#!/bin/bash
set -x
WEEK=`date +%w`
date=`date +%Y-%m-%d`

#log
exec 1>> /opt/backup/log/${date}.log
exec 2>> /opt/backup/log/${date}.log

#mkdir
mkdir -p /opt/backup/minio_${date}/local/{backup,sign,website}
mkdir -p /opt/backup/redis_${date}/{redis-0,redis-1,redis-2}
mkdir -p /opt/backup/etcd_${date}

#var
k8s_namespace='k8s_namespace'
backup_host='XXX.XXX.XXX.XXX'
etcd_server='https://XXX.XXX.XXX.XXX:2379'

#etcd-backup
ETCDCTL_API=3 /opt/kube/bin/etcdctl --cacert="/etc/kubernetes/ssl/ca.pem" --cert="/etc/etcd/ssl/etcd.pem" --key="/etc/etcd/ssl/etcd-key.pem" --endpoints=${etcd_server} snapshot save /opt/backup/etcd_${dat
e}/etcd-snapshot-${date}.db
#redis-backup
/opt/kube/bin/kubectl -n ${k8s_namespace} cp redis-0:/data/appendonly-redis.aof /opt/backup/redis_${date}/redis-0/appendonly-redis.aof -c redis
/opt/kube/bin/kubectl -n ${k8s_namespace} cp redis-1:/data/appendonly-redis.aof /opt/backup/redis_${date}/redis-1/appendonly-redis.aof -c redis
/opt/kube/bin/kubectl -n ${k8s_namespace} cp redis-2:/data/appendonly-redis.aof /opt/backup/redis_${date}/redis-2/appendonly-redis.aof -c redis

#minio-backup
if [ $WEEK -eq 5 ];then
    cd /opt/backup && ./mc mirror local/backup minio_${date}/local/backup/
    cd /opt/backup && ./mc mirror local/sign minio_${date}/local/sign/
    cd /opt/backup && ./mc mirror local/website minio_${date}/local/website/
else
    cd /opt/backup && ./mc mirror --newer-than 1d local/backup minio_${date}/local/backup/
    cd /opt/backup && ./mc mirror --newer-than 1d local/sign minio_${date}/local/sign/
    cd /opt/backup && ./mc mirror --newer-than 1d local/website minio_${date}/local/website/
fi

#package
cd /opt/backup && tar -zcf etcd_${date}.tar.gz etcd_${date}
cd /opt/backup && tar -zcf redis_${date}.tar.gz redis_${date}
cd /opt/backup && tar -zcf minio_${date}.tar.gz minio_${date}

#scp
cd /opt/backup && scp etcd_${date}.tar.gz ${backup_host}:/data/project-backup/etcd/
cd /opt/backup && scp redis_${date}.tar.gz ${backup_host}:/data/project-backup/redis/
cd /opt/backup && scp minio_${date}.tar.gz ${backup_host}:/data/project-backup/minio/

#rm
rm -rf /opt/backup/minio_* /opt/backup/redis_* /opt/backup/etcd_*
```

```bash
set -x
set -e
# var
filename="mysqlbak`date +%Y%m%d`.tar"
remote='XXX.XXX.XXX.XXX:/data/'
old_filename="mysqlbak`date -d "4 week ago" +"%Y%m%d"`.tar"

# operation
cd /opt/backups/
scp ${filename} ${remote}
rm -f ${old_filename}
```
### log backup
```bash
#!/bin/bash
set -x

exec 1>> /opt/scripts/project-prd/cron.log
exec 2>> /opt/scripts/project-prd/cron.log

#delete 30 days before
curl -XDELETE "http://XXX.XXX.XXX.XXX:9200/logstash*-`date -d '-30 day' +%Y.%m.%d`" -u elastic:Gn4M2zZBebciRlbFkaaa

#gzip 2 days before
cd /opt/export-logs/project-prd && gzip k8s-25.11-`date -d '-2 day' +%Y-%m-%d`.log

#rsync
rsync -avrzP /opt/export-logs/project-prd/k8s-25.11-`date -d '-2 day' +%Y-%m-%d`.log.gz root@XXX.XXX.XXX.XXX::logbackup/ --password-file=/etc/rsync.password
```