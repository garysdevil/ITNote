---
created_date: 2020-11-19
---

[TOC]

## 包管理工具

- 软件的安装可被拆分为两个对立的过程“解包”和“配置”。

### Ubuntu16

#### 概览

1. Debian系列的包名称 \*.deb
2. dpkg工具： 安装、删除、构建和管理Debian的软件包。
3. apt工具： 解决软件包之间的依赖问题。
   - Linux 包管理命令都被分散在了 apt-get、apt-cache 和 apt-config 这三条命令当中。
   - apt 指令的引入就是为了解决命令过于分散的问题，它包括了 apt-get 命令出现以来使用最广泛的功能选项，以及 apt-cache 和 apt-config 命令中很少用到的功能。
4. apt的底层包是dpkg, 而dpkg 安装Package时, 会将 \*.deb 放在 /var/cache/apt/archives/ 中。

#### 基本操作

```bash
# 1. 从软件源（也就是服务器）下载最新的软件包列表文件，更新本地软件源的软件包的索引记录（包含软件名，版本，校验值，依赖关系等）。
# 同步 /etc/apt/sources.list 和 /etc/apt/sources.list.d 中列出的源的索引。
apt update  

# 2. 在线或者离线安装deb包，可以自动修复依赖问题
apt install ./deb安装包

# 3. 根据update更新的索引记录来下载并更新软件包.
apt upgrade 

# 4. 除了拥有upgrade的全部功能外，dist-upgrade会比upgrade更智能地处理需要更新的软件包的依赖关系。
apt dist-upgrade # 或者 apt full-upgrade

# 5. 删除已安装包和依赖包，连配置文件一起删除
apt-get purge ${package_name}

# 6. 删除已安装包，连配置文件一起删除
apt-get --purge remove ${package_name} 

# 7. 删除为了满足依赖而安装的，但现在不再需要的软件包（包括已安装包），保留配置文件。
apt-get autoremove ${package_name}

# 8. 清理过期的缓存。将 /var/cache/apt/archives/ 的 所有 已经过期的deb 删掉。
apt-get autoclean
    
# 9. 清理缓存。将 /var/cache/apt/archives/ 的 所有 deb 删掉，可以理解为 rm /var/cache/apt/archives/*.deb
apt-get clean  
```

#### 其它

- PPA
  https://www.cnblogs.com/cute/archive/2012/05/21/2511571.html
  1. PPA 全称为 Personal Package Archives（个人软件包档案）
  2. FireFox PPA 源：https://launchpad.net/~ubuntu-mozilla-daily/+archive/ppa
  3. add-apt-repository ：在source.list里增删改查 ppa 源。
  4. 安装add-apt-repository
     apt-get install software-properties-common
  5. 格式
     add-apt-repository ppa:USER/PPA-ANME
     添加源 add-apt-repository -y ppa:fkrull/deadsnakes
     移除源 add-apt-repository -r ppa:jonathonf/python-3.6

#### 配置apt源

1. 软件源源位置

   - /etc/apt/sources.list
   - /etc/apt/sources.list.d

2. 源信息

   - https://blog.csdn.net/xiangxianghehe/article/details/80112149

3. 配置apt源

   ```bash
   # 获取系统代号
   lsb_release -c 
   # 编写源配置文件
   vi /etc/apt/sources.list
   ```

   ```conf
   deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
   deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

   deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
   deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

   deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
   deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

   deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
   deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

   deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
   deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
   ```

### Centos7

#### 概览

1. Red Hat系列的包名称 \*.rpm
2. rpm工具: 安装、删除、构建和管理Red Hat的软件包。
   - rpm操作没有安装的软件包，软件包使用的是包全名
   - rpm操作的已经安装的软件，软件包使用的是包名
3. rpm安装软件的默认路径
   /etc 配置文件放置目录
   /usr/bin 一些可执行文件
   /usr/lib 一些程序使用的动态链接库
   /usr/share/doc 一些基本的软件使用手册与说明文件
   /usr/share/man 一些man page档案

#### 基本操作

1. 查找所有的所有已经安装的软件包

   - rmp -qa

2. 安装软件包

   - rpm -ivh ${package_name} -U 更新或者安装 -e 删除软件包

3. 卸载软件包

   - rpm -e ${package_name}

4. yum清理已有缓存的软件包信息，创建新的软件包信息缓存

   - yum clean all
   - yum makecache

5. 查询软件源信息

   - yum repolist all

6. 彻底删除软件

   - yum history list all
   - yum history undo ID号

7. 查看软件包依赖关系

   - yum deplist package

8. 下载软件包在离线服务器上安装

   ```bash
    yum -y install xxx --downloadonly --downloaddir /opt/temp
    yum -y install https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.4.6.0-1.el7.ans.noarch.rpm --downloadonly --downloaddir /opt/temp
    
    # 诺无downloadonly选项 
    yum install yum-plugin-downloadonly
    # 默认 --downloaddir /var/cache/yum/$basearch/$releasever
    # 在离线的服务上执行安装操作 
    rpm -ivh *.rpm --nodeps --force 或 yum localinstall -y ./*.rpm
   ```

#### 配置yum源

1. 官方源镜像

   ```conf
   [centos-7-base]
   name=CentOS-$releasever - Base
   mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
   baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
   enabled=1
   gpgcheck=0
   ```

2. 其它源 CentOS7

   - 163源 http://mirrors.163.com/.help/CentOS7-Base-163.repo
   - aliyun源 http://mirrors.aliyun.com/repo/Centos-7.repo
   - epel源:是社区强烈打造的免费开源发行软件包版本库，系统包含大概有1万多个软件包 http://mirrors.aliyun.com/repo/epel-7.repo
   - 安装阿里云源

   ```bash
   curl -o /etc/yum.repos.d/Aliyun-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo
   ```

3. 安装epel源

   ```bash
   # 方式一
   # 大陆
   curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
   # wget http://mirrors.aliyun.com/repo/epel-7.repo -P /etc/yum.repos.d/

   # 非大陆
   wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   yum install epel-release-latest-7.noarch.rpm

   # 方式二
   yum install epel-release
   ```

4. yum仓库管理工具
   yum-config-manager
   yum-config-manager --add-repo repository_url

### Android

- 参考 http://www.mamicode.com/info-detail-2685312.html
-

```bash
# 1. 列出所有包：
apk search -v
# 2. 用通配符搜索包
apk search -v 'php7*'
# 3. 用包名安装包：
apk add pkgName1 pkgName2
# 4. 安装本地.apk 文件包
apk add --allow-untrusted /path/to/foo.apk
# 5. 通过名字删除包
apk del pkgName1 pkgName2   
# 6. 升级选中包
apk update
apk add -u htop
```

## 新的包管理工具

- appimage，snapd和flatpack都是把所有依赖都放包里的应用打包方式。

### appimage

### snapd

### flatpack
