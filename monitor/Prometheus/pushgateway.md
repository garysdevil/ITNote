##### 一 进程监控
```bash
pushgateway=XXX.XXX.XXX.XXX
port=9091
job=chain_index
instance=XXX.XXX.XXX.XXX

process=platonsync.py
process_num=`ps -ef | grep ${process} | grep -v grep | wc -l`

cat <<EOF | curl --data-binary @- http://${pushgateway}:${port}/metrics/job/${job}/instance/${instance}
# TYPE chain_index_process_num gauge
chain_index_process_num{process="${process}"} ${process_num}
EOF
```

#### 二 通过查看日志是否含有某个关键字来判断节点集群好坏 - 一下脚本有个小问题
1. 写监控脚本
mkdir  ~/pushgateway_script; cd ~/pushgateway_script && vim garys_status.sh
```bash
#!/bin/bash
# 监控集群中不同的节点需要修改的变量：instance, path
# 监控不同的集群需要修改的变量：chain_cluster
# 更换gateawypush需要修改的变量：pushgateway, port
set -e 
pushgateway=XXX.XXX.XXX.XXX
port=9091
job=chain_garys_log # 标签

instance=XXX.XXX.XXX.XXX # 标签
path=/home/rhine2/garysNode/node0/log/ # 日志所在的文件夹路径
chain_cluster=it-fiscosgarys # 标签 集群名称

line_num=368 # 最后1分钟左右的日志
cd $path
logfile=`ls -t | grep info_log | head -n 1`
# log_path=${path}${logfile}
key_word='HostSSL::reconnectAllNodes try to reconnect' # 标签
key_num=`tail -n ${line_num} ${logfile} | grep "${key_word}" | wc -l`

if [ $key_num -gt 0 ];then chain_garys_log_error=1; else chain_garys_log_error=0; fi

cat <<EOF | curl --data-binary @- http://${pushgateway}:${port}/metrics/job/"${job}"/instance/${instance}
# TYPE chain_garys_log_error gauge
chain_garys_log_error{key_word="${key_word}",chain_cluster="${chain_cluster}"} ${chain_garys_log_error}
EOF
```
2. 写定时采集任务
crontab -e
*/1 * * * * /bin/bash  ~/pushgateway_script/garys_status.sh >> ~/pushgateway_script/cron.log

3. 配置告警规则
根据不同的集群，对应修改expr和description
```yaml
groups:
- name: fisco-garys cluster status is not ok
  rules:
    - alert: fisco-garys cluster status is not ok
      expr: sum(chain_garys_log_error{chain_cluster="it-fiscosgarys",job="chain_garys_log",key_word="HostSSL::reconnectAllNodes try to reconnect"}) > 1
      labels:
        severity: high
      annotations:
        description:  it-fiscosgarys(XXX.XXX.XXX.XXX,XXX.XXX.XXX.XXX,XXX.XXX.XXX.XXX,XXX.XXX.XXX.XXX) 集群状态异常，节点异常数量 {{ $value }}
```