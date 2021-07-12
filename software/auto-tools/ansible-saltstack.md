# Ansible
## 安装
- 版本 https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/

## 离线安装ansible
```bash
# 1在有网的机器上执行的操作
yum -y install ansible --downloadonly --downloaddir /opt/ansible-pac
yum -y install createrepo --downloadonly --downloaddir /opt/createrepo-pac
tar czvf   /opt/ansible-pac.tar.gz  /opt/ansible-pac 
tar czvf  /opt/createrepo-pac.tar.gz  /opt/createrepo-pac
# 然后scp压缩包到没有网络的机器上

# 2无网的机器上执行的操作
tar xzvf  /opt/ansible-pac.tar.gz
tar xzvf  /opt/createrepo-pac.tar.gz
cd  /opt/createrepo-pac
rpm -ivh libxml2-python-*
rpm -ivh deltarpm-*
rpm -ivh python-deltarpm-*
rpm -ivh createrepo-*

createrepo /opt/ansible-pac
echo '[ansibel]
name=my local ansible
baseurl=file:///opt/ansible-pac
enabled=1
gpgcheck=0'  > /etc/yum.repos.d/ansible.yum.repo

yum clean all
yum makecache
yum  install ansible
```

## 基本

### 目录结构
- ansible.cfg  公共配置
- inventory
- playbooks.yaml
- vars/
- roles/
    - role1/main.yaml
    - role2/main.yaml

0. ansible.cfg 
```conf
[defaults]
host_key_checking = False
```
1. inventory
```conf
[组名]
localhost     ansible_connection=local
39.107.74.200 ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass='123' ansible_sudo_pass='123'
39.107.74.200 ansible_connection=ssh ansible_ssh_user=root ansible_ssh_private_key_file=~/.ssh/keyfile.pem
```

2. playbooks.yaml
```yaml
- name: Init
  hosts: default
  gather_facts: no
  roles:
    - role1
    - role2
```
3. /role1/main.yaml

#### 简单示范
```yaml
#!/usr/bin/env ansible-playbook
- name: set_host
  hosts: default
  become: true
  tasks:
    - name: set_host_1
      shell: array_doamin=('master.garys.top') && for domain in ${array_doamin[@]};do sed -i "/ ${domain}/c\\{{ domain_ip }}      ${domain}" /etc/hosts; done
```
```bash
ansible-playbook  -i hosts  simple.yaml --key-file  .test_rsa.pem  -e domain_ip=5.5.5.6
```
### 操作 
- 指令
```bash
# 运行剧本
ansible-playbook  apply-role.yml -e host=127.0.0.1,127.0.0.2 -e @'vars/DMZ'  -e role=filebeat
-i # 指定host文件
-e # 指定变量var1=value1,var2=value2 # 指定变量文件 @'vars/production'
--start-at="任务名称" # 从指定任务开始运行

"~/.ssh/mykey.pem" # ssh登入时使用密钥登入

# 测试ip是否通
ansible -i ./hosts ${IP_GROUP} -m ping
```

5. 查看模块的文档
    ansible-doc 模块名 

6. 运行时有效的模块
add_host
group_by

7. 其它
获取fact的参数：register

保存所有主机的facts: hostvars

手动获取fact：ansible 组名 -m setup -a 'filter=ansible_eth'


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

