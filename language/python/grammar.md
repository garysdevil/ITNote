## 基本数据类型：
1. 数字
2. 字符串
3. 列表：类似于数组，但比数组更灵活。li = [1,'12','abc',['a','123',1]] 或者 li = list('abcde')
4. 元组：只读。var_tuple = ('a','123',['a',123]) 或者 tuple('abcde')
5. 字典： K-V键值对。 var_dict = {'a': 1, 'b': 2, 'b': '3'}
6. 集合： 可变集合（set）和不可变集合（frozenset）

## 基本语法
```python
# __name__ 是当前模块名，当模块被直接运行时模块名为 __main__ 。当模块被直接运行时，代码将被运行，当模块是被导入时，代码不被运行。
if __name__ == '__main__':
    print('-')
```

## 常用的内置包
1. json格式化
```bash
echo '{"name": "lucy", "age": "18"}' | python -m json.tool
```

2. 解析文件中的unicode字符
```python
python
text = '\u4f60\u597d'
print text.decode('unicode_escape')
```

3. 交互式输入密码
```python
import getpass

if __name__ == '__main__':
    passphrase = getpass.getpass("请输入密码")
```

4. 操作系统相关的操作
```python
import os
# 设置环境变量，设置代理 export http_proxy="http://127.0.0.1:1081"
os.environ["http_proxy"] = "http://127.0.0.1:1081"
os.environ["https_proxy"] = "http://127.0.0.1:1081"
```