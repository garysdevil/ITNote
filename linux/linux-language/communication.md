---
created_date: 2020-11-27
---

[TOC]

### 本地进程间通信方式
IPC（Inter Process Communication）
1. 管道
2. 共享内存
3. 消息队列
4. Unix Domain Socket
文件锁

### UDS=unix domain socket
- 参考
https://xiazemin.github.io/MyBlog/linux/2018/09/21/unix_socket.html 
UDS传输不需要经过网络协议栈,不需要打包拆包等操作,只是数据的拷贝过程
server.sock作为建立UDS连接的唯一标识符
UDS连接建立完成之后在内存开辟一块空间，而server与client在这块内存空间中进行数据传输


### 线程间同步
进程的线程间的栈是独立的，堆是共享。  
1. 互斥锁，函数pthread_mutex_...
2. 读写锁，函数pthread_rwlock_...
3. 条件变量（不是锁，本质是维护了个等待队列），函数pthread_cond_...
4. 信号量，函数sem_init(...,0, ...）// 注意那个参数0
