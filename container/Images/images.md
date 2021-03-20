### 博客镜像
1. wordpress
https://hub.docker.com/_/wordpress/
docker run --name wordpress  --network host -e WORDPRESS_DB_HOST=127.0.0.1:3306 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=wordpress  -d wordpress


### 操作系统基础镜像
#### alpine:latest 5.58m
- 微型镜像 alpine
- https://alpinelinux.org/

1. Alpine Linux Docker 镜像基于 Alpine Linux 操作系统，后者是一个面向安全的轻型 Linux 发行版。
2. Alpine Linux 采用了 musl libc 和 busybox 以减小系统的体积和运行时资源消耗。在保持瘦身的同时，Alpine Linux 提供了自己的包管理工具 apk。
```Dockerfile
FROM alpine:3.12
```

#### ubuntu:18.04 63.3m