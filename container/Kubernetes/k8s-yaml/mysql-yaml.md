---
created_date: 2020-11-16
---

[TOC]

## 配置configmap
### 方式一 vi mysql.cnf
kubect create configmap mysql-cm --from-file=mysql.cnf
```yaml
[mysqld]
port = 3306
socket = /opt/mysql/datadir/mysql.sock
default-time_zone = '+8:00'
server-id = 1
pid-file = /opt/mysql/datadir/mysql.pid
bind_address = 0.0.0.0
character-set-client-handshake=FALSE
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
init_connect='SET NAMES utf8mb4'
max_connect_errors = 50000
max_connections = 5000
max_user_connections = 0
skip-name-resolve
skip_external_locking = ON
max_allowed_packet = 16M
sort_buffer_size = 2M
join_buffer_size = 128K
log_error = /opt/mysql/datadir/error.log
user = mysql 
tmpdir = /opt/mysql/datadir
datadir = /opt/mysql/datadir
log-bin = /opt/mysql/datadir/mysql-mysql-bin
#skip-grant-tables
log_bin_trust_function_creators = ON
sync_binlog = 1
expire_logs_days = 0
key_buffer_size = 160M
binlog_cache_size = 1M
binlog_format = ROW
lower_case_table_names = 1
max_binlog_size = 128M
connect_timeout = 60
interactive_timeout = 31536000
wait_timeout = 31536000
net_read_timeout = 30
net_write_timeout = 60
innodb_buffer_pool_size = 2G
innodb_buffer_pool_instances =  1
innodb_log_buffer_size = 128M
innodb_log_file_size = 128M
innodb_log_files_in_group = 2
innodb_log_group_home_dir = /opt/mysql/datadir
innodb_max_dirty_pages_pct = 30
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 1
innodb_data_file_path = ibdata1:512M:autoextend
innodb_thread_concurrency = 16
innodb_read_io_threads = 4
innodb_write_io_threads = 12
innodb_lock_wait_timeout = 60
innodb_rollback_on_timeout = on
innodb_file_per_table = 1
innodb_stats_sample_pages = 1
innodb_purge_threads = 1
innodb_stats_on_metadata = OFF
innodb_support_xa = 1
innodb_doublewrite = 1
innodb_checksums = 1
innodb_io_capacity = 500
#sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
sql_mode='NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
 
##[Replication variables]
gtid-mode = on
enforce-gtid-consistency = on
log-slave-updates = on
binlog_checksum = CRC32
#binlog_row_image = row
slave_sql_verify_checksum = on
slave_parallel_workers = 5
master_verify_checksum  =   ON
slave_sql_verify_checksum = ON
master_info_repository=TABLE
relay_log_info_repository=TABLE
 
#[Replication variables for Master] 
#auto_increment_increment
#auto_increment_offset
#rpl_semi_sync_master_enabled = on
#rpl_semi_sync_master_timeout = 10000
#rpl_semi_sync_master_wait_no_slave = on
#rpl_semi_sync_master_trace_level = 32
 
#[Replication variables for Slave]
#slave_net_timeout = 10
#relay_log_recovery = on
#log_slave_updates = on 
#max_relay_log_size = 1G
#relay_log = /opt/mysql/relaylog
#relay_log_purge = on
#rpl_semi_sync_slave_enabled = on
#rpl_semi_sync_slave_trace_level = 32
 
[mysqldump]
quick
max_allowed_packet = 16M
 
[mysqlhotcopy]
interactive-timeout
```
### 方式二 vi mysql.cnf.yaml
kubect create -f mysql.cnf.yaml
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-cm
  namespace: project-test
data:
  mysql.cnf: |-
    [mysqld]
    port = 3306
    socket = /opt/mysql/datadir/mysql.sock
    default-time_zone = '+8:00'
    server-id = 1
    pid-file = /opt/mysql/datadir/mysql.pid
    bind_address = 0.0.0.0
    character-set-client-handshake=FALSE
    character-set-server=utf8mb4
    collation-server=utf8mb4_general_ci
    init_connect='SET NAMES utf8mb4'
    max_connect_errors = 50000
    max_connections = 5000
    max_user_connections = 0
    skip-name-resolve
    skip_external_locking = ON
    max_allowed_packet = 16M
    sort_buffer_size = 2M
    join_buffer_size = 128K
    log_error = /opt/mysql/datadir/error.log
    user = mysql 
    tmpdir = /opt/mysql/datadir
    datadir = /opt/mysql/datadir
    log-bin = /opt/mysql/datadir/mysql-mysql-bin
    #skip-grant-tables
    log_bin_trust_function_creators = ON
    sync_binlog = 1
    expire_logs_days = 0
    key_buffer_size = 160M
    binlog_cache_size = 1M
    binlog_format = ROW
    lower_case_table_names = 1
    max_binlog_size = 128M
    connect_timeout = 60
    interactive_timeout = 31536000
    wait_timeout = 31536000
    net_read_timeout = 30
    net_write_timeout = 60
    innodb_buffer_pool_size = 2G
    innodb_buffer_pool_instances =  1
    innodb_log_buffer_size = 128M
    innodb_log_file_size = 128M
    innodb_log_files_in_group = 2
    innodb_log_group_home_dir = /opt/mysql/datadir
    innodb_max_dirty_pages_pct = 30
    innodb_flush_method = O_DIRECT
    innodb_flush_log_at_trx_commit = 1
    innodb_data_file_path = ibdata1:512M:autoextend
    innodb_thread_concurrency = 16
    innodb_read_io_threads = 4
    innodb_write_io_threads = 12
    innodb_lock_wait_timeout = 60
    innodb_rollback_on_timeout = on
    innodb_file_per_table = 1
    innodb_stats_sample_pages = 1
    innodb_purge_threads = 1
    innodb_stats_on_metadata = OFF
    innodb_support_xa = 1
    innodb_doublewrite = 1
    innodb_checksums = 1
    innodb_io_capacity = 500
    #sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
    sql_mode='NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
    
    ##[Replication variables]
    gtid-mode = on
    enforce-gtid-consistency = on
    log-slave-updates = on
    binlog_checksum = CRC32
    #binlog_row_image = row
    slave_sql_verify_checksum = on
    slave_parallel_workers = 5
    master_verify_checksum  =   ON
    slave_sql_verify_checksum = ON
    master_info_repository=TABLE
    relay_log_info_repository=TABLE
    
    #[Replication variables for Master] 
    #auto_increment_increment
    #auto_increment_offset
    #rpl_semi_sync_master_enabled = on
    #rpl_semi_sync_master_timeout = 10000
    #rpl_semi_sync_master_wait_no_slave = on
    #rpl_semi_sync_master_trace_level = 32
    
    #[Replication variables for Slave]
    #slave_net_timeout = 10
    #relay_log_recovery = on
    #log_slave_updates = on 
    #max_relay_log_size = 1G
    #relay_log = /opt/mysql/relaylog
    #relay_log_purge = on
    #rpl_semi_sync_slave_enabled = on
    #rpl_semi_sync_slave_trace_level = 32
    
    [mysqldump]
    quick
    max_allowed_packet = 16M
    
    [mysqlhotcopy]
    interactive-timeout
```
### 部署mysql
kubectl apply -f deployment-mysql_ceph.yaml
deployment-mysql_ceph.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  namespace: project-test
  name: mysql-svc1
  labels:
    app: mysql1
spec:
  ports:
  - name: mysql-port1
    port: 3306
    name: mysql1
    protocol: TCP
    targetPort: 3306
    name: http
    nodePort: 33306
  type: NodePort
  selector:
    app: mysql1
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  namespace: project-test
  name: mysql1
spec:
  selector:
    matchLabels:
      app: mysql1
  serviceName: "mysql-svc1"
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql1
    spec:
      containers:
      - name: mysql1
        imagePullPolicy: IfNotPresent
        image: harbor.i.garys.top/middleware/mysql-master:5.7 
        resources:
          requests:
            memory: "1G"
            cpu: "100m"
          limits:
            memory: "2G"
            cpu: "1"
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "XXXXXX"
        - name: MYSQL_ROOT_HOST
          value: "%"
        volumeMounts:
          - name: "mysql-data1"
            mountPath: "/opt"
          - name: "mysql-cm"
            mountPath: "/etc/my.cnf"
            subPath: mysql.cnf
        ports:
        - containerPort: 3306
          name: mysql1
      tolerations:
      - key: "project"
        operator: "Equal"
        value: "project"
        effect: "NoSchedule"
      nodeSelector:
        project: "project"
      volumes:
      - name: mysql-cm
        configMap:
          name: mysql-cm
  volumeClaimTemplates:
  - metadata:
      name: mysql-data1
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "project-ceph-rbd"
      resources:
        requests:
          storage: 100Gi
```

