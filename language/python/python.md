## Python
- 目录结构
    - Lib
        - site-packages
        - Standard packages
    - Scripts
        - pip.exe
    - python.exe

- 虚拟环境
    - 虚拟环境可以看作是原生Python的副本。

```bash
venv_name="python_1_venv"
python3 -m venv ~/devenv/${venv_name}
source ~/devenv/${venv_name}/bin/activate
```

## 依赖包
```bash
# 1. 获取环境中所有已经被安装了的包
pip3 freeze > ./requirements.txt
# 或者
pip3 list

# 2. 根据某一个项目的import语句来生成依赖
# 在项目的根目录下，依次输入如下指令
pip3 install pipreqs
pipreqs ./
# 执行完后，在这个项目下会生成一个requirements.txt文件，里面记录了该项目所用到的依赖

# 3. 新环境下安装依赖包的模块
pip3 install -r requirements.txt
pip install -r requirements.txt --force-reinstall --no-cache-dir
# --force-reinstall：强制重新安装所有包，即使已存在。
# --no-cache-dir：避免使用缓存，确保从源下载最新版本。
```