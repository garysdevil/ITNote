---
created_date: 2021-07-23
---

[TOC]

## 配置讲解
### /etc/sudoer
- root ALL=(ALL) ALL
    - 第一个ALL 允许哪个终端、机器访问 sudo
    - 第二个ALL 允许sudo以哪个用户的身份执行命令
    - 第三个ALL 允许用户以root身份执行什么命令

### /etc/shadow
- gary:$1$2Uu6yiEE$m4Pj3bKxVd9oLA74jj4F0/:18364:0:99999:7:::
    - 第一列 用户名
    - 第二列 被加密过的密码；‘ * ’或者是‘ ! ’表示这个用户无法进行登录操作。
    - 第三列 密码最近变更的时间；1970年1月1日作为1，每过一天加1；
    - 第四列 重设密码后多少天内密码不可再次被更动
    - 第八列 账户哪一天失效

### PAM(Pluggable Authentication Modules)
- /etc/ssh/sshd_config 默认是开启状态“UsePAM yes”
```conf
Port 22960 # 设置sshd监听端口
LoginGraceTime 30 
MaxAuthTries 3 # 错误尝试的次数限制为 3 次，3 次之后拒绝登录尝试
PermitRootLogin no # 禁止root登入
```

- pam_tally2
```bash
# 禁止/etc/ssh/denyuser文件内的用户通过ssh登录
vim /etc/pam.d/sshd
auth required pam_listfile.so item=user sense=deny file=/etc/ssh/denyuser onerr=succeed

# 查看test用户登录的错误次数及详细信息
pam_tally2 --user test

# 清空test用户的错误登录次数，即手动解锁
pam_tally2 --user test --reset

# 通过tty登录的用户，输入密码错误超过三次则锁定1分钟，包含root用户且root用户锁定2分钟
vim  /etc/pam.d/login
auth required pam_tally2.so deny=3 unlock_time=60 even_deny_root root_unlock_time=120

```

## First Machine
1. 创建用户
```bash
username=gary
useradd ${username}
passwd ${username}
```
2. Centos普通用户免密sudo
```bash
chmod u+w /etc/sudoers
# 设置可以sudo但需要密码
echo "${username}      ALL=(ALL)       ALL" >> /etc/sudoers
# 免密sudo
echo "${username}      ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers
chmod u-w /etc/sudoers
```

```conf
admin1  ALL=(root)    NOPASSWD:ALL,!/usr/sbin/visudo,!/usr/bin/su,!/usr/bin/passwd root,!/usr/bin/vi,!/usr/bin/vim,!/usr/bin/nano,!/usr/bin/echo,!/usr/bin/mv,!/usr/bin/cp
admin2  ALL=(root)    /usr/bin/apt

```

3. 禁止root登入
```bash
vim /etc/ssh/sshd_config
```
```conf
Port 22960 # 设置sshd监听端口
PermitRootLogin no # 禁止Root用户远程登入
```
```bash
systemctl restart sshd
```