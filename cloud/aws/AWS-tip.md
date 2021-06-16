1. 磁盘在线扩容
    - https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html

2. 添加多个IP
    1. 实例 --> 联网 --> 管理私有IP地址 --> 分配新IP
    2. 
    ```bash
    ip addr add 10.2.22.218/19 dev eth0
    echo 'ip addr add 10.2.22.218/19 dev eth0' >> /etc/rc.local
    ```
    3. 弹性 --> 关联弹性IP地址 --> 网络接口