---
created_date: 2020-12-04
---

[TOC]

# docker

https://docs.docker.com

## 安装docker

- 官方步骤：
  https://docs.docker.com/install/linux/docker-ce/ubuntu/\
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
# aws服务器安装docker异常，执行 rm /etc/yum.repos.d/docker-ce.repo && amazon-linux-extras install docker

# 启动docker-ce
systemctl start docker
# 使docker跟随系统一起启动
systemctl enable docker.service
```

### ubuntu安装docker

```bash
# 删除旧的版本
apt-get remove docker docker-engine docker.io containerd runc
apt-get update
# 设置仓库源
apt-get install ca-certificates curl gnupg lsb-release -y
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 设置Docker稳定版仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# add-apt-repository "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# 设置Docker稳定版仓库 国内阿里云仓库 
# add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# 安装docker引擎
apt-get update -y
# 安装时禁止任何弹窗
DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFOLD=1 apt-get install -y \
-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动docker服务
systemctl enable docker
systemctl start docker
```

## 安装docker-compose

```bash
# 1. github上查看最新的docker-compose版本,获取下载链接
# https://github.com/docker/compose/releases/
# 2. 下载
curl -L https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

# 给目录增加可执行权限
chmod +x /usr/local/bin/docker-compose
```

## 常用指令

### Docker

```bash
# 1. Build 构建镜像
docker build --build-arg PROJECT=pre --no-cache --network=host -f Dockerfile -t ${url}:${image_tag} .

# 2. Run 运行镜像
docker run -d -e SW_OAP_ADDRESS=127.0.0.1:11800 -p 9000:9000 -v /etc/nginx/html:/var/www/html skyapm/skywalking-php
# docker run <image-name> <command> arg1 arg2
# -e 参数
# -p 映射端口 主机端口:容器端口
# --network host 直接使用宿主机的网络栈，不需要手动映射端口
# -v 主机路径:容器路径
# -d 后台运行
# --name 指定容器名字
# --network=host 设置容器的网络方式
# --rm 当容器停止时删除镜像
# --tty --interactive 启动容器后进行交互操作

# 3. 容器资源使用情况
docker stats --no-stream

# 4. 查看容器状态的详细信息
docker inspect ${container_id}

# 5. 将当前容器打包成镜像
docker commit  ${容器名称或id} ${打包的镜像名称}:${标签}
docker commit  centos7 garysdevil/blockscout:latest
# 可选项说明：
# -a :提交的镜像作者；
# -c :使用Dockerfile指令来创建镜像；
# -m :提交时的说明文字；
# -p :在commit时，将容器暂停，默认 -p。

# 6. 推送镜像进远程仓库
# docker image tag hub.docker.com/repository/docker/garysdevil/blockscout:test garysdevil/blockscout:latest
docker image push garysdevil/blockscout:latest

# 创建卷、bridge网络
docker network create --driver bridge my-network
docker volume create my-volume
# 使用方式 -v my-volume:/var/lib/postgresql/data
# 使用方式 --network my-network

docker save image:tag -o ${image_name}
docker load -i ${image_name}

```

### Dockerfile

1. 从编译阶段的中拷贝编译结果到当前镜像中

```dockerfile
COPY --from=builder /build/server /
```

2. 直接从一个已经存在的镜像中拷贝

```dockerfile
COPY --from=quay.io/coreos/etcd:v3.3.9 /usr/local/bin/etcd /usr/local/bin/
```

- 基本语法

```dockerfile
FROM 基础镜像
ARG 输入参数健=输入参数值
MAINTAINER 作者
RUN 执行命令
ADD 添加文件
WORKDIR 指定默认路径
ENV 环境变量键1=环境变量值 环境变量键2=环境变量值
ENV 环境变量键 环境变量值
USER 指定用户
VOLUME 挂载点
EXPOSE 暴露端口1,暴露端口
ENTRYPOINT 容器入口，不会被docker启动指令覆盖掉
CMD 容器入口指令，可以被docker启动指令覆盖掉
```

### docker-compose

```bash
docker-compose up -d

docker-compose down

docker-compose down -v
```

## docker配置更改

### 登陆docker仓库Harbor

1. 通过密钥-手动创建secret

- `cat /root/.docker/config.json | base64 -w`

2. 通过密钥-自动创建secret

```bash
kubectl create secret docker-registry 密钥的名字 --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER
--docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL
```

3. 通过docker登陆生成认证文件，然后认证文件考到kubelet认证下

```bash
docker login DOCKER_REGISTRY_SERVER
cp ~/.docker/config.json /var/lib/kubelet/
```

### 更改docker存储目录与镜像仓库地址

- 参考文档 https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file

- vi /etc/docker/daemon.json

```conf
{
  # 1. 更改镜像仓库地址
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  # "registry-mirrors":["https://mirror.ccs.tencentyun.com/"], ;腾讯云专用

  #  docker存储目录，默认为 /var/lib/docker
  "data-root": "/data1/docker/data-root",
  # docker执行状态文件的根目录，默认为 /var/run/docker
  "exec-root": "/data1/docker/exec-root",
  # 容器实例代理 # 未实践成功
  "proxies": {
    "default": {
        "httpProxy": "代理ip:port",
        "httpsProxy": "代理ip:port",
        "noProxy": ""
    }
  }
}
```

- 更改docker存储目录 方式三
  - 更改service里的启动方式 ExecStart=/usr/bin/dockerd --graph /home/docker

## 配置docker可以使用宿主机的GPU

```sh
# 添加 NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 安装 NVIDIA 容器工具包
sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker

# 重启 Docker
sudo systemctl restart docker
```

```sh
# 确保 Docker 已正确配置 GPU 支持。运行以下命令检查： 如果成功，会看到 GPU 信息
docker pull nvidia/cuda:12.3.0-base-ubuntu20.04
docker run --rm --gpus=all nvidia/cuda:12.3.0-base-ubuntu20.04 nvidia-smi
```

## 其它

1. 使普通用户也可以操作docker

```bash
# 将普通用户添加进docker用户组
#sudo groupadd docker     # 添加docker用户组 ，如果安装了docker，默认会存在，只需要执行下面的即可
sudo gpasswd -a ${username} docker     #将 登陆用户加入到docker用户组中
newgrp docker     # 更新用户组
```
