### 安装python3.6
1. 实践成功
国内 https://www.jb51.net/article/178358.htm
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
2. 通过特定的镜像源下载
pip install 安装包 -i http://pypi.douban.com/simple --trusted-host 源镜像

pip install -r requirement.txt -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
pip install psycopg2 -i http://pypi.douban.com/simple --trusted-host pypi.douban.com

3. 安装国内的镜像源
~/.pip/pip.conf
```
[global]
timeout = 6000
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
```
4.  pip在python中的位置
/usr/local/lib/python3.6/dist-packages/pip (python 3.6)