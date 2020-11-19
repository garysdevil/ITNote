## 手动编译
gcc *.c 默认生成a.out可执行文件

gcc -c 创建目标文件
gcc -o 定义生成的可执行文件名 目标文件名  
-O 进行优化 
-Wall 编译时输出更多的信息

make  在一个文件夹里建立一个文件makefile，写入编译规则。
make clean 可执行文件 ：先清除再编译


静态编译 ：将函数库也编译进可执行文件里。
动态编译 ：将函数库的指针编译进可执行的文件里。


/etc/ld.so.conf 记录编译时使用的动态链接库的路径，默认情况下编译器只会使用/lib和/usr/lib这两个目录下的库文件。
将函数库加载到内存中 ： ldconfig  /etc/ld.so.conf
将/etc/ld.so.conf中的路径缓存到/etc/ld.so.cache中，在安装完一些库文件或者修改ld.so.conf增加新的路径后需要运行一下/sbin/ldconfig使所有的库文件都缓存在ld.so.cache中。


ldd : 查看某个可执行文件有什么动态函数库。


## 
1. 配置并且生成Makefile文件
./configure
 --prefix=/软件要安装的路径
2. 根据Makefile进行编译
make
3. 安装
make install

4. 卸载
make uninstall




