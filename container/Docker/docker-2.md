# docker
https://docs.docker.com

## 安装docker
- 官方步骤：
https://docs.docker.com/install/linux/docker-ce/ubuntu/
说明：2017年的3月1号之后,新版本的免费版本为docker-ce
### centos安装docker
```bash
# yum 安装docker-ce
# 1.安装依赖
# yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的
yum install -y yum-utils  device-mapper-persistent-data lvm2

# 2.添加docker下载仓库
# 官方仓库
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# 阿里云仓库
# yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 查看docker-ce的版本
# yum list docker-ce --showduplicates | sort -r
# 3.默认安装最新版
yum install -y  docker-ce 

# 启动docker-ce
systemctl start docker
# 使docker跟随系统一起启动
systemctl enable docker.service
```
### ubuntu安装docker
```bash
apt-get remove docker docker-engine docker.io containerd runc
apt-get update -y
apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
# 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
# 设置Docker稳定版仓库
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# 国内阿里云仓库 add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y
```
## 安装docker-compose
```bash
# 1. github上查看最新的docker-compose版本,获取下载链接
# https://github.com/docker/compose/releases/
# 2. 下载
# curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
# 给目录增加可执行权限
chmod +x /usr/local/bin/docker-compose
```

## 常用指令
### Docker
1. 容器资源使用情况
docker stats --no-stream
### Dockerfile
1. 从编译阶段的中拷贝编译结果到当前镜像中
```dockerfile
COPY --from=builder /build/server /
```
2. 直接从一个已经存在的镜像中拷贝
```dockerfile
COPY --from=quay.io/coreos/etcd:v3.3.9 /usr/local/bin/etcd /usr/local/bin/
```
3. Run
docker run -d -e SW_OAP_ADDRESS=127.0.0.1:11800 -p 9000:9000 -v /etc/nginx/html:/var/www/html skyapm/skywalking-php
-e 参数
-p 主机端口:容器端口
-d 主机路径:容器路径
--name 指定容器名字

## docker配置更改
### 登陆docker仓库Harbor
1. 通过密钥-手动创建secret
cat /root/.docker/config.json | base64 -w

2. 通过密钥-自动创建secret
kubectl create secret docker-registry 密钥的名字 --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER
--docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL

3. 通过docker登陆生成认证文件，然后认证文件考到kubelet认证下
docker login DOCKER_REGISTRY_SERVER
cp ~/.docker/config.json /var/lib/kubelet/

### 更改docker存储目录与镜像仓库地址
- 参考文档 https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file
vi /etc/docker/daemon.json 
1. 更改镜像仓库地址
```bash
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "data-root": "/www/docker"
}
2. 更改docker存储目录
ExecStart=/usr/bin/dockerd --graph /home/docker
# 或者
{
    "graph":"/data/docker"
}
```

## 镜像
### 微型镜像alpine
- https://alpinelinux.org/

1. Alpine Linux Docker 镜像基于 Alpine Linux 操作系统，后者是一个面向安全的轻型 Linux 发行版。
2. Alpine Linux 采用了 musl libc 和 busybox 以减小系统的体积和运行时资源消耗。在保持瘦身的同时，Alpine Linux 提供了自己的包管理工具 apk。
```Dockerfile
FROM alpine:3.12
```