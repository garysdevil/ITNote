[TOC]

## 相关链接
- Github https://github.com/gogs/gogs
- 安装教程 https://gogs.io/docs/installation

## 安装Git服务Gogs
```bash
# 安装Postgresql数据库，下载二进制包
./gogs web --port 3000 # 默认端口为3000
```

```conf
START_SSH_SERVER = true # 开启ssh访问方式
SSH_PORT = 2222 # ssh监听的端口
```

## 同步仓库
```bash 
git clone --bare 源git仓库地址
cd project.git/
git push --mirror 目标git仓库地址

# 更新
git fetch
git remote update --prune origin
git push --mirror 目标git仓库地址 # 通过http方式
git push --mirror ssh://git@gogs.garys.top:2222/AleoHQ/snarkOS.git # 通过ssh方式
```

## 同步仓库（未使用）
```bash
# 同步仓库

repo_origin_url=https://github.com/AleoHQ/snarkVM
# 使用--mirror会将所有分支内容都拉下来
git clone --mirror ${repo_origin_url}

# 将远端已经删除的分支在本地清理掉
git remote update --prune origin


repo_target_url=http://gogs.garys.top/AleoHQ/snarkVM
# 同步所有分支
git push -f --prune --all ${repo_target_url}
# 同步tag
git tag --sort==-createordate | head -n2000 | git push -f ${repo_target_url}
```