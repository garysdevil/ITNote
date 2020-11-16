
### 安装部署
-  一般建议consul采用集群模式安装，以3+2方式部署，但如受资源限制可采用3server方式部署
```bash
# 1、创建consul文件夹
datadir=/opt/consul/datadir
conf=/opt/consul/conf
mkdir -p ${datadir} ${conf}

# 2、安装consul(使用consul1.6.0)
# 2.1、解压consul压缩文件
unzip consul_1.6.0_linux_amd64.zip
# 2.2、配置到/usr/bin
mv consul /usr/bin
# 2.3、验证
consul --version
# 出现一下信息则为成功
---
Consul v1.6.0 Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)为可用
---

# 3、配置consul
# 3.1、在${conf}中增加consul.json
---
ip1=172.16.211.143
ip2=172.16.211.144
ip3=172.16.211.145
node_name=consul01
bootstrap_expect=1
{
"data_dir": "${datadir}",
"log_level": "INFO",
"node_name": "${node_name}",
"server": true,
"ui": true,
"bootstrap_expect": ${bootstrap_expect},
"bind_addr": "${ip1}",
"client_addr": "${ip1}",
"retry_join": ["${ip2}","${ip2}"],
"retry_interval": "10s",
"protocol": 3,
"raft_protocol": 3,
"enable_debug": false,
"rejoin_after_leave": true,
"enable_syslog": false
}
# 在三台服务器上分别配置该json，需修改内容：
"node_name": "",（不能重复） # 数字字母
"bootstrap_expect": 1,（第一台server就填写1，第二台server就填写2）
"bind_addr": "",（填写本机IP）
"client_addr":""(作为 Client 接受请求的绑定 IP;端口使用了 HTTP: 8500, DNS: 8600)
"retry_join":(尝试加入其他Server)
---

# 在三台服务器上分别启动consul
nohup consul agent -config-dir ${conf} >> ./consul.log 2>&1 &

# 验证,通过web界面访问
consul http://bind_addr:8500

```
### 运维须知
1. 默认端口
	HTTP: 8500
	DNS: 8600
	RPC: 8300
	LAN: 8301
	WAN: 8302

2. CLI
- 查看集群的健康状况
consul members --http-addr 127.0.0.1:8500
- 热更新服务配置
consul reload
- 输出所有数据中心的的节点
consul members -wan
3. UI界面
${bind_addr}:HTTP端口/ui

4. API
- 查询所有的节点
curl ${client_addr}:HTTP端口/v1/status/peers
例如： curl 127.0.0.1:8500/v1/status/peers
- 查询所有的服务 
curl ${client_addr}:HTTP端口/v1/agent/services\?pretty
例如： curl 127.0.0.1:8500/v1/agent/services\?pretty
- 查询某个服务的详细信息
url http://${client_addr}:HTTP端口/v1/catalog/service/服务名
passing=true ： 过滤掉不健康的节点
- 查询leader
curl ${client_addr}:HTTP端口/v1/status/leader
例如：curl http://127.0.0.1:8500/v1/status/leader
- 查询失败的健康检查
 curl -s http://localhost:8500/v1/health/state/critical\?pretty
- 查询所有的键值信息
curl  http://localhost:8500/v1/kv/?recurse
- 查询所有的数据中心
curl http://localhost:8500/v1/catalog/datacenters
- 查询某个数据中心的所有节点
curl http://localhost:8500/v1/catalog/nodes?dc=dc1

### 学习
- 参考资料
https://blog.csdn.net/liuzhuchen/article/details/81913562
https://www.consul.io/docs/index.html
提供服务注册，健康检查，键值存储，多数据中心

启动模式：server，client
Clent:不会把信息持久化在本地，无状态的，负责转发所有的RPC到server节点。
Server：负责组成 cluster 的复杂工作（选举、状态维护、转发请求到 lead），以及 consul 提供的服务（响应 RCP 请求）。考虑到容错和收敛，一般部署 3 ~ 5 个比较合适。

1. 启动配置
server：定义agent运行在server模式
bootstrap-expect ：在一个datacenter中期望提供的server节点数目，当该值提供的时候，consul一直等到达到指定sever数目的时候才会引导整个集群，该标记不能和bootstrap共用
bind：该地址用来在集群内部的通讯，集群内的所有节点到地址都必须是可达的，默认是0.0.0.0
node：节点在集群中的名称，在一个集群中必须是唯一的，默认是该节点的主机名
ui-dir： 提供存放web ui资源的路径，该目录必须是可读的
rejoin：使consul忽略先前的离开，在再次启动后仍旧尝试加入集群中。
config-dir：配置文件目录，里面所有以.json结尾的文件都会被加载
client：consul服务侦听地址，这个地址提供HTTP、DNS、RPC等服务，默认是127.0.0.1所以不对外提供服务，如果你要对外提供服务改成0.0.0.0

2. 注册服务
- 可以通过提供服务定义文件（放入${-config-dir}文件夹下）或者调用HTTP API来注册一个服务.
- json格式
{
  "ID": "userServiceId", //服务id
  "Name": "userService", //服务名
  "Tags": [              //服务的tag，自定义，可以根据这个tag来区分同一个服务名的服务
    "primary",
    "v1"
  ],
  "Address": "127.0.0.1",//服务注册到consul的IP，服务发现，发现的就是这个IP
  "Port": 8000,          //服务注册consul的PORT，发现的就是这个PORT
  "EnableTagOverride": false,
  "Check": {             //健康检查部分
    "DeregisterCriticalServiceAfter": "90m",
    "HTTP": "http://www.baidu.com", //指定健康检查的URL，调用后只要返回20X，consul都认为是健康的
    "Interval": "10s"   //健康检查间隔时间，每隔10s，调用一次上面的URL
  }
}
- 注册
curl http://127.0.0.1:8500/v1/agent/service/register -X PUT -i -H "Content-Type:application/json" -d '{
 "ID": "userServiceIdAA",  
 "Name": "userServiceAA",
 "Tags": [
   "primary",
   "v1"
 ],
 "Address": "127.0.0.1",
 "Port": 8000,
 "EnableTagOverride": false,
 "Check": {
   "DeregisterCriticalServiceAfter": "2m",
   "HTTP": "http:127.0.0.1:9999",
   "Interval": "60s"
 }
}'

3. KV键值存储
- 值 以base64的形式存储
- cli操作存取
	+ consul kv put ${key} ${value}
	例如： consul kv put user/config/connections 5
	+ consul kv get -detailed ${key}
	consul kv get -detailed user/config/connections
- API操作存取
	+ curl -X PUT -d ${key}  http://localhost:8500/v1/kv/${value}
	例如 curl -X PUT -d 'test' http://localhost:8500/v1/kv/web/key2?flags=42
	+ curl -s http://localhost:8500/v1/kv/${key}
	 curl -s http://localhost:8500/v1/kv/web/key2

- 更改键的值
先通过 curl -s http://localhost:8500/v1/kv/${key} 查到ModifyIndex
curl -X PUT -d 'newval' http://localhost:8500/v1/${key}?cas=${ModifyIndex}

- 规定时间内等待键的值被改变
 curl "http://localhost:8500/v1/kv/${key}?index=${ModifyIndex}&wait=时间"
 例如  curl "http://localhost:8500/v1/kv/web/key2?index=502663&wait=5s"

4. 深度了解
一致性协议采用Raft算法
成员管理和消息广播采用GOSSIP协议，支持ACL访问控制

Consul使用两个不同的gossip池
- Consul使用gossip协议来管理成员和广播消息到集群。Serf库实现了gossip协议。
- Consul使用两个不同的gossip池，分别称为LAN和WAN池。
LAN gossip池: 每个数据中心都有一个LAN池。
LAN gossip池目的：运行client，自动发现server，减少配置量；gossip池允许可靠和快速的事件广播，比如leader选举。

WAN池：全局唯一的，所有的server都应该加入WAN池，不论是哪个数据中心的。
WAN Pool提供会员信息让Server节点可执行跨数据中心的请求。


5. 
服务注册过程，至少将存储正在运行的主机和端口服务。
服务发现过程，允许其他人能够发现我们在注册过程中存储的信息。
