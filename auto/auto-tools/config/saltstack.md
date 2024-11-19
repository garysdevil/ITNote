# saltstack
服务端修改
master：
interface:192.168.1.1
服务注册修改：
https://blog.51cto.com/7870873/1642419

客户端修改
minion：
master:192.168.1.1
id: ID

systemctl stop firewalld && sed -i '/#master: salt/a\master: 172.16.212.126' /etc/salt/minion && systemctl restart salt-minion

- master和minion的交互
Saltstack默认使用zeromq传递消息，zeromq会随着Salt的安装而安装，他是一个消息队列服务，master通过4505端口将指令放入zeromq的队列中，而所有的minion都会监听master的4505端口，然后从队列中拿消息进行对比决定是否进行操作，如果操作将自己操作的结果丢回zeromq另外一个队列，master从4506端口监听该队列，得到返回结果，然后展示出来

4505         # 发送指令
4506          # 接受结果

## 安装
```bash
apt-get install python-software-properties
add-apt-repository  ppa:saltstack/salt
apt-get update
apt-get install salt-master    #服务端
apt-get install salt-minion    #客户端
```
## 端口
- master
4505（publish_port）—Salt Master pub接口 提供远程执行命令发送功能
4506（ret_port）—Salt Master Ret接口 支持认证、文件服务、结果收集等功能


## 指令
salt 执行salt的执行模块，通常在master端运行
salt-cp 分发文件到minion上,不支持目录分发，通常在master运行
salt-key 密钥管理，通常在master端执行
salt-master master运行命令
salt-run
salt-syndic

salt-call minion自己执行可执行模块，不通过master下发job

