### 安装python3.6
```bash
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:fkrull/deadsnakes
apt-get update
apt-get -y install python3.6 python3.6-dev python3-pip
python3.6 -m pip install --upgrade pip -i https://pypi.douban.com/simple
which python3.6
```

### pip
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