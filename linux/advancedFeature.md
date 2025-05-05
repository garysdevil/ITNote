---
created_date: 2020-11-16
---

[TOC]


## 文件描述符fd
- linux中， 每一个进程在内核中，都对应有一个“打开文件”数组，存放指向文件对象的指针，而 fd 是这个数组的下标。
- fd的类型为int， < 0 为非法值， >=0 为合法值。在linux中，一个进程默认可以打开的文件数为1024个，fd的范围为0~1023。可以通过设置，改变最大值。
- fd 0 是stdin，1 是stdout，2 是stderr。
```bash
# Linux系统下，所有进程允许打开的最大fd数量
cat  /proc/sys/fs/file-max
# Linux系统下，所有进程已经打开的fd数量及允许的最大数量
cat  /proc/sys/fs/file-nr
# 单个进程允许打开的最大fd数量
ulimit -n
# 单个进程已经打开的fd
ls -l /proc/$PID/fd/
```

## 进程间通信
进程间通信的方式有很多，常见的有信号，信号量，消息队列，管道，共享内存，和socket等
参考 https://blog.csdn.net/love_gaohz/article/details/6636661

## 管道
|
xargs

## exec
参考 https://blog.csdn.net/qq_31186123/article/details/82190776
- 使用 exec 命令可以并不启动新的 Shell，而是使用执行命令替换当前的 Shell 进程，并且将老进程的环境清理掉，而且 exec 命令后的其他命令将不再执行。
- exec命令基本功能
```bash
# 1. 在shell中执行ls，ls结束后不返回原来的shell中了
exec ls
# 2. 将file中的内容作为exec的标准输入
exec < file
# 3. 将file中的内容作为标准写出
exec > file
# 4. 将file读入到fd3中
exec 3< file
# 5. fd3中读入的内容被分类输出
sort <&3 
# 6. 将写入fd4中的内容写入file中
exec 4>file      
# 7. ls将不会有显示，直接写入fd4中了，即上面的file中
ls >&4      
# 8. 创建fd4的拷贝fd5
exec 5<&4         
# 9. 关闭fd3
exec 3<&-  
# 10
echo "foo bar" > file   # write string "foo bar" to file "file".
exec 5<> file           # open "file" for rw and assign it fd 5.
read -n 3 var <&5       # read the first 3 characters from fd 5.
echo $var
```



## mkfifo
参考 https://notes.tweakblogs.net/blog/7955/using-netcat-to-build-a-simple-tcp-proxy-in-linux.html
```bash
# 终端1
mkfifo fifo
exec < fifo
# 终端2
exec 3> fifo;
echo 'echo test' >&3
```
实现端口转发进行代理的功能
```bash
# 代理
nc -kl 8888 < fifo | nc garyss.top 80 > fifo
# 通过代理进行访问
http_proxy=localhost:8888 curl  garyss.top
```

```bash tcp-proxy.sh
#!/bin/sh -e

if [ $# != 3 ]
then
    echo "usage: $0 <src-port> <dst-host> <dst-port>"
    exit 0
fi

TMP=`mktemp -d`
BACK=$TMP/pipe.back
SENT=$TMP/pipe.sent
RCVD=$TMP/pipe.rcvd
trap 'rm -rf "$TMP"' EXIT
mkfifo -m 0600 "$BACK" "$SENT" "$RCVD"
sed 's/^/ => /' <"$SENT" &
sed 's/^/<=  /' <"$RCVD" &
nc -l -p "$1" <"$BACK" | tee "$SENT" | nc "$2" "$3" | tee "$RCVD" >"$BACK"
```
./tcp-proxy.sh 8080 garyss.top 80