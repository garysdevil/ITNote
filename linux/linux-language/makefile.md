---
created_date: 2020-11-16
---

[TOC]

# makefile
- 参考文档 
https://blog.csdn.net/lms1008611/article/details/85200983
https://blog.csdn.net/weixin_38391755/article/details/80380786

## 概念
- 为什么使用makefile
从职责分工来说，Shell script是给系统管理员用的，Makefile是给软件配置管理员或者Release Engineer用的。
解决项目间的依赖问题。

- 作用
一个工程中的源文件不计其数，其按类型、功能、模块分别放在若干个目录中，makefile定义了一系列的规则来指定哪些文件需要先编译，哪些文件需要后编译，哪些文件需要重新编译，甚至于进行更复杂的功能操作

##  编译链接讲解
 1. 编译时，编译器需要的是语法的正确，函数与变量的声明的正确。对于后者，通常是你需要告诉编译器头文件的所在位置（头文件中应该只是声明，而定义应该放在C/C++文件中），只要所有的语法正确，编译器就可以编译出中间目标文件。（O文件或是OBJ文件）
 2. 链接时，主要是链接函数和全局变量。 (.lib  或者 .a文件)
 3. 可执行文件
## 指令
make 
-C 进入某个目录下执行make 
-f 指定makefile的名字

## 语法 
### 特有语法
1. shell
    1. 每次执行一次shell指令起一个bash环境。
    2. 如果shell指令相互之间没有使用';' 或 ';\'连接起来，则不共享一个bash环境。

2. 变量的赋值
    1. = 是最基本的赋值
    2. := 是覆盖之前的值
    3. ?= 是如果没有被赋值过就赋予等号后面的值
    4. += 是添加等号后面的值

3. 变量值的传递
    1. $var：将Makefile中的变量var的值，传给shell指令。
    2. $$var：访问shell指令中定义的变量var。
### 实践学习
1. 自定义函数 define关键开头，并以endef关键字结束.
```makefile
define fun1
	指令
endef
```

2. 目标 依赖 伪目标
目标和依赖默认是文件
默认只执行第一个目标
```makefile
.PHONY: 目标 # 定义目标是伪造的：无论目标是何种情况都执行命指令
目标 : 依赖 # 依赖文件更新时间早于目标文件更新时间则执行指令
    指令
```
make Makefile 目标1 目标2 ...

3. 自定义函数使用预定义函数call调用，后边跟自定义函数名及参数
```makefile
.PHONY : test  
define fun1
	@echo "My name is $(0)"
endef

define fun2
	@echo "My name is $(0), param is $(1)"
endef
test:  # 定义了一个伪目标test
	$(call fun1)
	$(call fun2, hello Makefile)
```
4. 变量/内置变量
```makefile
var := $(abspath ./)
test2 :
	@echo $(var)
    @echo $@ # 目标文件
    @echo $^ # 所有的依赖文件
    @echo $< # 第一个依赖文件
```

5. 文件搜索
```makefile
vpath < pattern> < directories>    为符合模式< pattern>的文件指定搜索目录<directories>。
vpath < pattern>                   清除符合模式< pattern>的文件的搜索目录。
vpath                              清除所有已被设置好了的文件搜索目录。
```
6. 忽略命令的出错
- make会检测每个命令的返回码，如果命令返回成功，那么make会执行下一条命令
- 在Makefile的命令行前加一个减号“-”
```makefile
  clean:
     -mkdir foldername
```

6. 嵌套执行make
- 例如有一个子目录叫subdir，这个目录下有个Makefile文件
总控的Makefile可以这样书写
```makefile
   subsystem:
           cd subdir && $(MAKE)

其等价于：
    subsystem:
           $(MAKE) -C subdir
```
- 传递变量到下级Makefile中，使用这样的声明：
```makefile
export <variable ...>
export # 表示传递所有的变量
```