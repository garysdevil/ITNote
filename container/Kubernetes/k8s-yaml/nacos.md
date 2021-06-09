- 官网 https://nacos.io/en-us/
- 文档 https://nacos.io/zh-cn/docs/deployment.html

# nacos
- 依赖
    - Java JDK 1.8
    - Mysql
    - Nacos

- 默认端口
    - 8848
## nacos vs apollo
1. nacos配置文件支持比较多的格式，支持yaml、text、json、xml、html、Properties，apollo只支持xml、text、Properties的格式，没有兼容springboot中比较通用的yaml配置。

## 部署

### 使用已有的StorageClass创建部署nacos
0. git clone https://github.com/nacos-group/nacos-k8s.git

1. 增加namespace键值 和 更改storageClassName键值，然后执行创建pvc
kubectl apply -f nacos-k8s/deploy/ceph/pvc.yaml

3. 增加nodeSlector字段tolerations字段，创建主从数据库
kubectl create -f nacos-k8s/deploy/mysql master-ceph -n 指定命名空间
kubectl create -f nacos-k8s/deploy/mysql  slave-ceph -n 指定命名空间

4. 增加nodeSlector字段tolerations字段，更改StorageClass，删除ServiceAccount键值。去掉requests。更改ConfigMap的密码。然后执行创建pvc。
deploy/nacos/nacos-pvc-ceph.yaml 

5. 部署nacos
kubectl create -f  nacos-k8s/deploy/nacos/nacos-quick-start-ceph.yaml -n 指定命名空间

6. 登陆nacos的web界面
http://10.200.79.70:38848/nacos/index.html#/login
nacos/nacos

### 裸部署
- https://github.com/alibaba/nacos/tree/2.0.1

1. 下载2.0版本
```bash
wget https://github.com/alibaba/nacos/releases/download/2.0.1/nacos-server-2.0.1.tar.gz
```
2. 修改配置
vim conf/application.properties 
```conf
spring.datasource.platform=mysql  # 不去掉注解则默认使用嵌入式数据库
db.num=1
db.url.0=jdbc:mysql://127.0.0.1:3306/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
db.user=nacos
db.password=nacos
```
3. 创建数据库倒入表结构
```sql
grant all privileges on nacos.* to 'nacos'@'%' identified by 'nacos';
create database nacos;
use nacos;
source conf/nacos-mysql.sql
```
4. 集群nacos 配置
    - cp cluster.conf.example cluster.conf
    - cluster.conf
    ```conf
    ${IP1}:8848
    ${IP2}:8848
    ${IP3}:8848
    ```

5. 部署单节点模式nacos
```bash
# 默认后台启动
bin/startup.sh -m standalone

# 使用内置Derby数据库需要保证~/nacos/data/derby-data文件夹下无残留数据
bash startup.sh -m standalone -p embedded

```
6. 部署集群模式nacos
```bash
# 默认后台启动
sh startup.sh -m cluster
```

7. 查看启动日志
```bash
tail -f logs/start.out
```
### docker-compose
1. 部署单节点nacos
```bash
git clone https://github.com/nacos-group/nacos-docker
cd nacos-docker
# 可以更改example/standalone-mysql-5.7.yaml
docker-compose -f example/standalone-mysql-5.7.yaml up -d
```

### 默认端口
- HTTP 8848
- 9848
- 9849
- Raft 7848 

## API
1. 发布配置  
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=gary.group&content=HelloWorld"
2. 获取配置  
curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=gary.group&tenant=命名空间ID"