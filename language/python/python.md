## Django
python manage.py runserver 127.0.0.1:8000
startapp

python manage.py inspectdb t_cmdb_app_info > acd/models.py


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

```