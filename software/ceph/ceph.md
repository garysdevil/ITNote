### ceph
- 参考文档
https://docs.ceph.com/docs/master/start/intro/
https://blog.csdn.net/zzq900503/article/details/80098084

- Ceph将数据作为对象存储在逻辑存储池中。
- 4个组件：
    - Monitors ceph-mon  负责监视Ceph集群，维护Ceph集群的健康状态；维护着Ceph集群中的各种Map图。
    - Managers ceph-mgr  管理员。包括基于Web的Ceph Manager Dashboard和 REST API。
    - Ceph OSDs ceph-osd 存储数据。提供一些监控数据给ceph-mon和ceph-mgr。
    - MDSs ceph-mds      存储ceph文件系统的元数据。使用文件存储时才用到。（非必装组件）

- ceph 客户端 rbd可执行程序

### 操作指令
1. 打印pool列表
ceph osd lspools

2. 创建pool
通常在创建pool之前，需要覆盖默认的pg_num，官方推荐：
    若少于5个OSD， 设置pg_num为128。
    5~10个OSD，设置pg_num为512。
    10~50个OSD，设置pg_num为4096。
    超过50个OSD，可以参考pgcalc计算。
osd pool default pg num = 128
osd pool default pgp num = 128

ceph osd pool create {pool-name} {pg-num}
ceph osd pool create test-pool 128

设置最多可以有多少个对象
ceph osd pool set-quota test-pool max_objects 100

设置允许每个对象的容量限制为10GB
ceph osd pool set-quota test-pool max_bytes $((10 * 1024 * 1024 * 1024))

3. 
重命名 pool
ceph osd pool rename test-pool test-pool-new

4. 删除一个pool会同时清空pool的所有数据，因此非常危险。(和rm -rf /类似）。因此删除pool时ceph要求必须输入两次pool名称，同时加上--yes-i-really-really-mean-it选项。
ceph osd pool delete test-pool test-pool  --yes-i-really-really-mean-it

5. 查看pool状态信息
rados df

6. 获取当前副本数
ceph osd pool get $test-pool size

### old
10-80-93-153 10-80-88-115 10-80-101-43
10.80.93.153
10.80.88.115
10.80.101.43

https://cbs.centos.org/kojifiles/packages/python-itsdangerous/0.23/1.el7/noarch/python-itsdangerous-0.23-1.el7.noarch.rpm
rpm -Uvh 

vim ceph.conf默认osd为3，根据需求修改配置
osd pool default size = 2
当monitor为多节点时 public network =192.168.197.0/24

ceph-deploy --overwrite-conf config push node1 node2 node3

yum install -y ceph ceph-radosgw
或者每台机器上执行ceph-deploy install admin-node node1 node2 node3

监控节点：添加；初始化mon，收集所有密钥；摧毁
ceph-deploy new node1 node2 node3
ceph-deploy mon create-initial
ceph-deploy mon destroy node1 node2 node3
添加
ceph-deploy --overwrite-conf mon create node2
ceph-deploy mon add node3
查看存储节点的硬盘：
ceph-deploy disk list node1

创建osd存储节点
格式化，创建osd，激活
ceph-deploy disk zap 10-80-93-153:/dev/vdb
ceph-deploy osd prepare 10-80-93-153:/dev/vdb
ceph-deploy osd activate 10-80-93-153:/dev/vdb

查看ceph集群的osd树
ceph osd tree

自从ceph 12开始，manager是必须的。应该为每个运行monitor的机器添加一个mgr，否则集群处于WARN状态。

卸载：
https://www.xiaocaicai.com/2019/05/ceph-deploy-%E6%B8%85%E7%90%86/

/var/lib/kubelet/config.yaml
systemctl restart kubelet
cat /sys/fs/cgroup/memory/system.slice/memory.limit_in_bytes

3ef5beb0-88a0-4c16-a4e9-a3ce4a27e5c6


对象存储（RADOSGW）、块存储RDB以及 CephFS 文件系统
https://github.com/ceph/ceph
https://github.com/ceph/ceph-ansible
https://docs.ceph.com/docs/master/start/documenting-ceph/


