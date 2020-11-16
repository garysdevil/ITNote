
# linux 命令
1. selinux
```bash
# 查看当前selinux功能情况
sestatus -v
# 1永久改变selinux的状态（重启后生效）
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sed -i 's/SELINUXTYPE=targeted/#&/' /etc/selinux/config
# 2临时改变selinux的状态
setenforce 0
```

# Unix命令行程序和内建指令(更多)
文件系统	
▪ cat	▪ cd	▪ chmod	▪ chown
▪ chgrp	▪ cksum	▪ cmp	▪ cp
▪ du	▪ df	▪ fsck	▪ fuser
▪ ln	▪ ls	▪ lsattr	▪ lsof
▪ mkdir	▪ mount	▪ mv	▪ pwd
▪ rm	▪ rmdir	▪ split	▪ touch
▪ umask			
程序	
▪ at	▪ bg	▪ chroot	▪ cron
▪ exit	▪ fg	▪ jobs	▪ kill
▪ killall	▪ nice	▪ pgrep	▪ pidof
▪ pkill	▪ ps	▪ pstree	▪ sleep
▪ time	▪ top	▪ wait	
使用环境	
▪ env	▪ finger	▪ id	▪ logname
▪ mesg	▪ passwd	▪ su	▪ sudo
▪ uptime	▪ w	▪ wall	▪ who
▪ whoami	▪ write		
文字编辑	
▪ awk	▪ comm	▪ cut	▪ ed
▪ ex	▪ fmt	▪ head	▪ iconv
▪ join	▪ less	▪ more	▪ paste
▪ sed	▪ sort	▪ strings	▪ talk
▪ tac	▪ tail	▪ tr	▪ uniq
▪ vi	▪ wc	▪ xargs	
Shell 程序	
▪ alias	▪ basename	▪ dirname	▪ echo
▪ expr	▪ false	▪ printf	▪ test
▪ true	▪ unset		
网络	
▪ inetd	▪ netstat	▪ ping	▪ rlogin
▪ netcat	▪ traceroute		
搜索	
▪ find	▪ grep	▪ locate	▪ whereis
▪ which			
杂项	
▪ apropos	▪ banner	▪ bc	▪ cal
▪ clear	▪ date	▪ dd	▪ file
▪ help	▪ info	▪ size	▪ lp
▪ man	▪ history	▪ tee	▪ tput
▪ type	▪ yes	▪ uname	▪ whatis