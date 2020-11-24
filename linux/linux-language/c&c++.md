## GCC
gcc *.c 默认生成a.out可执行文件
-o 自定义生成的可执行文件名
-c 进行编译和汇编但不链接
-static 静态编译
-O 快速编译
-Wall 编译时输出更多的信息

## make
1. 配置并且生成Makefile文件
./configure
 --prefix=/软件要安装的路径
2. 根据Makefile进行编译
make
3. 安装
make install

4. 卸载
make uninstall

5. 將之前产生的可执性文件和其它文件删除
make clean 

## 编译与函数库
### 概念
1. 静态编译：将函数库也编译进可执行文件里。
2. 动态编译：将函数库的指针编译进可执行的文件里。

3. 动态库以.so为扩展名；静态库以.a为扩展名。

### Linux可执行文件（ELF文件）
ELF = Executable and Linkable Format
- 组成
    1. 程序头：描述段信息
    2. Section头：链接与重定位需要的数据
    3. 程序头与Section头需要的数据.text .data
1. 查看ELF文件的具体信息
readelf -a ${file}



### 相关文件与指令
1. /etc/ld.so.conf 文件
文件记录编译时使用的动态链接库的搜索路径，默认情况下编译器只会使用/lib和/usr/lib两个目录下的库文件。

2. /sbin/ldconfig 可执行命令
将/etc/ld.so.conf 中的函数库路径刷新到/etc/ld.so.cache中，及内存中。
-p 查看缓存里的所有函数库

3. /bin/ldd  可执行命令
作用：查看函数库所依赖的共享库文件。常用来解决程序因缺少某个库文件而不能运行的一些问题。
lld *.so -v
第一列：程序需要依赖什么库 
第二列: 系统提供的与程序需要的库所对应的库 
第三列：库加载的开始地址

5. lib/
lib 包含目标文件(object files)与库。
lib32 表示32位，32位的目标文件和库。
lib64 表示32位，64位的目标文件和库。
libexec 包含不由用户和shell script直接执行的二进制文件。