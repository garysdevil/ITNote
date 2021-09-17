## 基本数据类型：
数字
字符串
列表：类似于数组，但比数组更灵活。li = [1,'12','abc',['a','123',1]] 或者 li = list('abcde')
元组：只读。a = ('a','123',['a',123]) 或者 tuple('abcde')
字典： K-V键值对
集合： 可变集合（set）和不可变集合（frozenset）

## Django
python manage.py runserver 127.0.0.1:8000
startapp



python manage.py inspectdb t_cmdb_app_info > acd/models.py


## 获取依赖包：

1. 获取环境中所有安装的包

打开命令提示符，在某条路径下输入pip freeze > ./requirements.txt


2. 根据某一个项目的import语句来生成依赖

打开命令提示符，将路径切换到需要生成依赖的项目的根目录下，依次输入：

pip install pipreqs

pipreqs ./

执行完后，在这个项目下会生成一个requirements.txt文件，里面记录了该项目所用到的依赖

3. 新环境下安装依赖包的模块

pip install -r requirements.txt


## 常用的内置包
1. json格式化
echo '{"name": "lucy", "age": "18"}' | python -m json.tool

2. 解析文件中的unicode字符
```python
python
text = '\u4f60\u597d'
print text.decode('unicode_escape')
```