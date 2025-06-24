## 链接

1. https://github.com/browser-use/browser-use
2. https://github.com/browser-use/web-ui

## browser-user

```sh
# 下载代码
git clone https://github.com/browser-use/web-ui.git
cd web-ui

# 创建新的python虚拟环境
uv venv --python 3.11
source .venv/bin/activate

# 安装依赖
uv pip install -r requirements.txt
playwright install --with-deps

# 配置环境变量
cp .env.example .env

# 启动
python webui.py --ip 127.0.0.1 --port 7788
```
