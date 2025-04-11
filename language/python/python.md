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
# 1. 获取当前python环境中所有已经被安装了的依赖包
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

## 编程思想
### 代码风格 
1. PEP 8（Python Enhancement Proposal 8）是 Python 的官方代码风格指南，由 Guido van Rossum（Python 创始人）和 Barry Warsaw 于 2001 年 提出并正式发布。
2. 目的： 为 Python 开发者提供统一的代码风格标准，以提高代码的可读性和一致性。
3. 核心目标： 
    1. 一致性：所有 Python 代码遵循相同风格，降低认知负担。
    2. 可读性：代码不仅是给机器执行的，更是给人阅读的。
    3. 可维护性：统一的风格便于团队协作和长期维护。
4. 后续受影响的产品： Black，Ruff

```sh
pip install black
black your_file.py  # 格式化单个文件
black .             # 格式化整个项目
```

```sh
pip install ruff
ruff check .          # Lint 检查
ruff check --fix      # Lint 检查，并且进行自动修复
ruff format .         # 格式化代码
```