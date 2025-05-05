---
created_date: 2024-11-19
---

[TOC]

# Ansible

- 参考
  - https://docs.ansible.com/ansible/latest/installation_guide/index.html

## 安装

- 版本 https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/

### 离线安装ansible

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

## 操作

### 目录结构

- ansible.cfg 公共配置
- inventory
- playbooks.yaml
- vars/
- roles/
  - role_name_1/tasks/main.yaml
  - role_name_1/handlers/main.yaml
  - role_name_1/templates/\*.j2
  - role_name_1/files/
  - role_name_2/main.yaml

1. ansible.cfg

```conf
[defaults]
host_key_checking = False
ssh_args = -C -o ControlMaster=auto -o ControlPersist=1d
```

2. inventory

```conf
[组名]
localhost     ansible_connection=local
39.107.74.200 ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass='123' ansible_sudo_pass='123'
39.107.74.200 ansible_connection=ssh ansible_ssh_user=root ansible_ssh_private_key_file=~/.ssh/keyfile.pem
[组名:vars]
```

3. playbooks.yaml

```yaml
- name: Init
  hosts: default
  gather_facts: no
  roles:
    - role_name_1
    - role_name_2
```

4. /role_name_2/main.yaml

```yaml
- name: Update apt cache.
  apt: update_cache=yes cache_valid_time=86400
  changed_when: false
```

### 一个简单的剧本

```yaml
#!/usr/bin/env ansible-playbook
- name: set_host
  hosts: default
  vars:
    var1: testfile
  become: true # sudo
  tasks:
    - name: set_host_1
      shell: array_doamin=('master.garys.top') && for domain in ${array_doamin[@]};do sed -i "/ ${domain}/c\\{{ domain_ip }}      ${domain}" /etc/hosts; done
```

```bash
ansible-playbook  -i hosts  simple.yaml --key-file  .test_rsa.pem  -e domain_ip=5.5.5.6
```

### 指令

- ansible 指令

```bash
# 运行剧本
ansible-playbook  apply-role.yml -e host=127.0.0.1,127.0.0.2 -e @'vars/DMZ'  -e role=filebeat
-i # 指定host文件
-e # 指定变量var1=value1,var2=value2 # 指定变量文件 @'vars/production'
--start-at="任务名称" # 从指定任务开始运行

"~/.ssh/mykey.pem" # ssh登入时使用密钥登入

# 测试ip是否通
ansible -i ./hosts ${IP_GROUP} -m ping

# 手动获取fact
ansible 组名 -m setup -a 'filter=ansible_eth'

# 配置文件检查
ansible-playbook  --syntax-check when_mc.yaml 
```

- ansible-doc 指令

  - 查看模块的文档
  - ansible-doc 模块名

- ansible-lint 指令

  - 需要安装ansible-lint的软件包
  - ansible-lint 是一个对playbook的语法进行检查的工具。

### 语法

1. 运行时有效的模块

   - add_host
   - group_by

2. 获取fact的参数：register

3. 保存所有主机的facts: hostvars
