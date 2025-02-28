## 安装python3.6
### Linux
```bash
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:fkrull/deadsnakes
apt-get update
apt-get -y install python3.6 python3.6-dev python3-pip
python3.6 -m pip install --upgrade pip -i https://pypi.douban.com/simple
which python3.6
```

### Windows
- anaconda 方式: Anaconda中包含了conda等180多个科学包及其依赖项。其中conda则是一个开源的软件包管理系统和环境管理系统，用于安装多个版本的软件包及其依赖关系，并在它们之间轻松切换。

1. https://www.anaconda.com/ 下载安装
2. 设置环境变量
```bash
setx PATH "%PATH%;D:\APP\DEV\Anaconda3;D:\APP\DEV\Anaconda3\Scripts;D:\APP\DEV\Anaconda3\Library\bin"
```
```bash
conda --version
conda info

pip --version

# 查看虚拟环境
conda env list

# 激活一个虚拟环境
conda activate ${ENV}

# 初始化 conda 环境的命令。它用于配置 shell，使其能够使用 conda 命令。
conda init
conda init powershell # powershell代表你要执行conda init的shell
conda init cmd.exe

```

## pip
https://blog.csdn.net/zwliang98/article/details/83546788
1. 安装
    ```bash
    wget https://bootstrap.pypa.io/get-pip.py
    python3.6 get-pip.py
    # python3.6 get-pip.py -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
    pip -V  如果pip -V，出现notfound，把pip加到环境变量
    ```

3. 通过指令查看与配置镜像源
    ```bash
    pip3 config list
    pip3 config set global.index-url http://pypi.douban.com/simple/
    pip3 config set global.trusted-host pypi.douban.com/
    ```

2. 通过特定的镜像源下载包
    ```bash
    packet_name="psycopg2" # 包名
    origin_domain="pypi.douban.com" # 镜像源地址
    pip install ${packet_name} -i http://${origin_domain}/simple --trusted-host ${origin_domain}

    pip install -r requirement.txt -i http://${origin_domain}/simple --trusted-host ${origin_domain}
    ```

3. 配置国内的包镜像源 ~/.pip/pip.conf
    ```conf
    [global]
    timeout = 6000
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    trusted-host = pypi.tuna.tsinghua.edu.cn
    ```

4.  pip在python中的位置
    - /usr/local/lib/python3.6/dist-packages/pip (python 3.6)