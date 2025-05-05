---
created_date: 2025-03-07
---

[TOC]

## Django
- https://www.djangoproject.com/
- 文档 https://www.osgeo.cn/django/intro/tutorial01.html
- 文档 https://docs.djangoproject.com/zh-hans/4.1/
```bash
# 创建并进入一个虚拟环境
venv_name="python_openai_venv"
python3 -m venv ~/devenv/${venv_name}
python3 -m venv 虚拟环境路径 --python=Python解释器路径

source ~/devenv/${venv_name}/bin/activate

# 安装Django与创建项目
pip3 install Django==4.1.4
# 查看安装的Django版本
python3 -m django --version 
# 创建项目工作空间
project_name="mydjango"
mkdir ${project_name} && cd ${project_name}
# 创建一个Django项目
sub_project_name="mysite"
django-admin startproject ${sub_project_name} .  
# 创建一个应用程序
sub_project_name="openai"
python3 manage.py startapp ${sub_project_name}
```

- 项目目录结构
    1. ${project_name}: 项目的容器。
    2. manage.py: 一个实用的命令行工具，可让你以各种方式与该 Django 项目进行交互。
    3. django_study/init.py: 一个空文件，告诉 Python 该目录是一个 Python 包。
    4. django_study/asgi.py: 一个 ASGI 兼容的 Web 服务器的入口，以便运行你的项目。(Django3.x版本可见)
    5. django_study/settings.py: 该 Django 项目的设置/配置。
    6. django_study/urls.py: 该 Django 项目的 URL 声明; 一份由 Django 驱动的网站"目录"。
    7. django_study/wsgi.py: 一个 WSGI 兼容的 Web 服务器的入口，以便运行你的项目。


```bash
# 启动服务 127.0.0.1:8000为默认端口
python3 manage.py runserver 127.0.0.1:8000

# 创建后台管理
python3 manage.py migrate # 创建sqlite3数据库表格
python3 manage.py createsuperuser # 创建管理员

# 导入
python manage.py inspectdb t_cmdb_app_info > acd/models.py
```

## pyinstaller
- 打包为可执行文件
```sh
# 安装 Python：确保已安装 Python（建议 3.7 或更高版本）。
pip install pyinstaller

# 假如要打包的文件名称是main.py，打完完成后 dist/ 目录下会生成 main.exe。
pyinstaller -F main.py -n myapp
# -F 表示将所有内容打包为单个可执行文件（单文件模式）。
# -i icon.ico 添加图标（仅 Windows 支持）。
# -n myapp 指定输出名称
# --upx-dir 指定UPX程序所在的文件夹目录路径，使用upx压缩可执行文件 https://github.com/upx/upx/releases
```

## tkinter
- 图形化界面库
- tkinter 是 Python 标准库
```sh
brew install python-tk@3.12
/opt/homebrew/bin/python3.12 -c "import _tkinter; print(_tkinter.TCL_VERSION)"
```

## pdb
- 运行时进行交互式调试
- Python 3.7+：可以用 breakpoint() 替代 pdb.set_trace()，无需导入 pdb。
```py
import pdb
def main():
    x = 10
    pdb.set_trace()  # 设置断点，运行到这里会暂停
    y = x + 5
    print(y)
if __name__ == "__main__":
    main()
```
1. 在终端运行生成的可执行文件，程序会在 pdb.set_trace() 处暂停，进入交互式调试模式。可以使用以下命令：
    1. n（next）：执行下一行代码，但不会进入函数内部（单步跳过）。
    2. s（step）：执行下一行代码，如果遇到函数调用，会进入函数内部（单步进入）。
    3. c（continue）：继续运行程序，直到遇到下一个断点或程序结束。
    4. p variable：打印指定变量的值，例如 `p x` 显示变量 `x` 的当前值。
    5. l（list）：显示当前代码的上下文，默认显示 11 行（当前行居中）。可以加参数，例如 `l 10, 20` 显示第 10 到 20 行。
    6. w（where）


## pre-commit
```sh
pre-commit --version

# 配置 pre-commit 钩子，编辑 .pre-commit-config.yaml 文件

# 将 pre-commit 钩子安装到 .git/hooks/pre-commit 中
pre-commit install

# 验证钩子是否安装
ls .git/hooks/pre-commit

# 检查所有 repo 的最新版本，并更新配置文件里的 rev 字段
pre-commit autoupdate

# 手动运行
pre-commit run --all-files
```

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.11.5
    hooks:
      - id: ruff
        args: [--fix]  # 自动修复 linting 问题
      - id: ruff-format
```

## detect-secrets
- 安全检查
```sh
pip install detect-secrets
# 初始化 detect-secrets
detect-secrets scan > .secrets.baseline
```

- 钩子中添加敏感信息检查，提交时会自动检测敏感信息。

```yaml
- repo: https://github.com/Yelp/detect-secrets
  rev: v1.4.0
  hooks:
    - id: detect-secrets
      args: [--baseline, .secrets.baseline]
```


## tomli
- Python 3.11+ 内置 tomllib（读写）。
