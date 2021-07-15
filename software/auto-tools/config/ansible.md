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

## 基本

### 目录结构
- ansible.cfg  公共配置
- inventory
- playbooks.yaml
- vars/
- roles/
    - common/main.yaml
    - role1/main.yaml
    - templates/
    - files/

0. ansible.cfg 
```conf
[defaults]
host_key_checking = False
ssh_args = -C -o ControlMaster=auto -o ControlPersist=1d

```
1. inventory
```conf
[组名]
localhost     ansible_connection=local
39.107.74.200 ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass='123' ansible_sudo_pass='123'
39.107.74.200 ansible_connection=ssh ansible_ssh_user=root ansible_ssh_private_key_file=~/.ssh/keyfile.pem
[组名:vars]
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
```yaml
- name: Update apt cache.
  apt: update_cache=yes cache_valid_time=86400
  changed_when: false
```

#### 一个简单的剧本
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


