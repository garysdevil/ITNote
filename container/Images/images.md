# 镜像
- Docker镜像官网（Docker Hub）: https://hub.docker.com
- 阿里云容器Hub：https://dev.aliyun.com
- Google镜像（gcr.io）：https://console.cloud.google.com/gcr/images/google-containers/GLOBAL
（需要科学上网，主要为Kubernetes相关镜像）

## 博客镜像
1. wordpress
https://hub.docker.com/_/wordpress/
docker run --name wordpress  --network host -e WORDPRESS_DB_HOST=127.0.0.1:3306 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=wordpress  -d wordpress


## 操作系统基础镜像
### busybox
- https://www.busybox.net/
- https://hub.docker.com/_/busybox/

- 一个超级简化版嵌入式Linux系统

```Dockerfile
FROM busybox
COPY ./my-static-binary /my-static-binary
CMD ["/my-static-binary"]
```

### alpine:latest 5.58m
- https://alpinelinux.org/

1. Alpine Linux Docker 镜像基于 Alpine Linux 操作系统，后者是一个面向安全的轻型 Linux 发行版。
2. Alpine Linux 采用了 musl libc 和 busybox 以减小系统的体积和运行时资源消耗。在保持瘦身的同时，Alpine Linux 提供了自己的包管理工具 apk。
```Dockerfile
FROM alpine:3.12
```

### CentOS
- RedHat的社区版操作系统

- https://www.centos.org/
- https://hub.docker.com/_/centos/

```Dockerfile
FROM centos:7
ENV container docker
```

```bash
docker run -d --name centos7 centos:7 sleep 6000
```

### ubuntu

- http://www.ubuntu.com/
- https://hub.docker.com/_/ubuntu/

```Dockerfile
FROM ubuntu:18.04
```

```Dockerfile
FROM ubuntu:20.04
MAINTAINER garysdevil
WORKDIR /opt/blockscout
```

```bash
repath=/Users/gary/git/project/ # The folder path of repository bitcoinops.github.io
cd ${repath}

git clone https://github.com/bitcoinops/bitcoinops.github.io

docker run -d --name bitcoinops -p 4000:4000 -v ${repath}/bitcoinops.github.io:/root/bitcoinops.github.io ruby:2.6.4-stretch sleep 31536000
docker exec -w /root/bitcoinops.github.io  bitcoinops  bundle install

docker exec -w /root/bitcoinops.github.io  bitcoinops  make preview
```

```bash
repath=/Users/gary/git/project/ # The folder path of repository bitcoinops.github.io
cd ${repath}

git clone https://github.com/bitcoinops/bitcoinops.github.io

docker run -d --name bitcoinops -p 4000:4000 -v ${repath}/bitcoinops.github.io:/root/bitcoinops.github.io -w /root/bitcoinops.github.io ruby:2.6.4-stretch /bin/bash -c "bundle install && make preview"
```

## 其它
- 包含web界面的Ubuntu镜像 https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/