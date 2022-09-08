## gcc
- gcc 是c&c++语言的编译器。
- 使用gcc编译的时候，只会默认链接一些基本的c语言标准库（例如libc.a或者libc.so)，有很多的依赖库（例如非标准库、第三方库等）是需要工程师在使用gcc编译指令时，在指令后面加上要链接的库。
```bash
path=./main.c
gcc ${path} # 默认生成a.out可执行文件
# 参数
# -o 自定义生成的可执行文件名
# -c 进行编译和汇编但不链接
# -static 静态编译
# -O 快速编译
# -Wall 编译时输出更多的信息
```

## make
- 问题： 当依赖库很多时，gcc编译时需要手动链接的库就很多，不是一个很好的编译方式。
- 解决方案： make 指令根据 Makefile 文件中写的内容进行编译和链接，生成一个独立的可执行程序。解决使用gcc编译时手动添加的库的问题。
- make 指令执行的是增量编译。
```bash
# 配置并且生成Makefile文件
./configure
# --prefix=软件要安装的路径

# 根据Makefile进行编译 
make

# 安装
make install

# 卸载
make uninstall

# 將之前产生的可执性文件和其它文件删除，再次执行make install即可进行全量编译
make clean 
```

## cmake
- 问题： 当工程非常大的时候，手写Makefile也是一件麻烦的事，而且Makefile也不是万能的，换了一个别的平台，Makefile又得重写。
- 解决方案： cmake 是可以跨平台项目管理的工具，它根据 CMakeLists.txt 文件自动生成 Makefile 文件。

## 函数库
### 概念
- 编译
    1. 静态编译：将函数库也编译进可执行文件里。
    2. 动态编译：将函数库的指针编译进可执行的文件里。
- 库
    1. 动态库以 .so 为扩展名.
    2. 静态库以 .a 为扩展名。

### Linux可执行文件（ELF文件）
1. ELF = Executable and Linkable Format
2. ELF文件组成
    1. 程序头：描述段信息
    2. Section头：链接与重定位需要的数据
    3. 程序头与Section头需要的数据.text .data
1. 查看ELF文件的具体信息 `` readelf -a ${file} ``



### 相关文件与指令
1. /etc/ld.so.conf 文件记录编译时使用的动态链接库的搜索路径，默认情况下编译器只会使用/lib和/usr/lib两个目录下的库文件。

2. lib目录
    1. /lib 包含目标文件(object files)与库。
    2. /lib32 表示32位，32位的目标文件和库。
    3. /lib64 表示32位，64位的目标文件和库。
    4. libexec 包含不由用户和shell script直接执行的二进制文件。

3. `` /sbin/ldconfig `` 指令
    1. 功能： 将/etc/ld.so.conf 中的函数库路径刷新到/etc/ld.so.cache中，及内存中。
    2. 参数： -p 查看缓存里的所有函数库。

4. `` /bin/ldd ``  指令
    1. 功能： 查看函数库所依赖的共享库文件。常用来解决程序因缺少某个库文件而不能运行的一些问题。
    2. `` lld 文件名.so -v ``
        1. 第一列：程序需要依赖什么库 
        2. 第二列: 系统提供的与程序需要的库所对应的库 
        3. 第三列：库加载的开始地址

