---
created_date: 2022-09-21
---

[TOC]


- 库

### Ubuntu c++ 开发环境
```bash
apt-get update  

# 安装编译器和调试器
apt-get install build-essential manpages-dev  gdb
# 如果成功，则显示版本号
# gcc --version
# g++ --version
# gdb --version

apt install cmake
```

- 库
  - cmake  https://github.com/Kitware/CMake/

### glibc
```bash
ll /lib/x86_64-linux-gnu/libc.so.6
```
#### 安装方式一 Ubuntu20
- 基于 https://github.com/bminor/glibc
    ```bash
    git clone https://github.com/bminor/glibc && cd glibc
    git checkout glibc-2.34
    mkdir build && cd build
    ../configure  --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
    make
    make install
    ```

1. 问题一
    ```log
    *** These auxiliary programs are missing or incompatible versions: makeinfo
    *** some features will be disabled.
    *** Check the INSTALL file for required versions.
    checking LD_LIBRARY_PATH variable... contains current directory
    configure: error: 
    *** LD_LIBRARY_PATH shouldn't contain the current directory when
    *** building glibc. Please change the environment variable
    *** and run configure again.
    ```
    - 第一种方案 `` export LD_LIBRARY_PATH= ``
    - 第二种方案 清空 LD_LIBRARY_PATH 目录下的文件

2. 问题二
    ```log
    configure: error: 
    *** These critical programs are missing or too old: bison
    ```
    ```bash
    apt-get install autopoint
    git clone https://github.com/akimd/bison && cd bison
    git checkout v3.8.2 
    ...
    ```

3. 问题二
    ```log
    /usr/include/linux/errno.h:1:10: fatal error: asm/errno.h: No such file or directory
        1 | #include <asm/errno.h>
    ```
    - 解决方案 ``ln -s /usr/include/asm-generic /usr/include/asm``

4. 问题三
    ```log
    fatal error: asm/prctl.h: No such file or directory
    ```

5. 问题四
    ```log
    These auxiliary programs are missing or incompatible versions: msgfmt makeinfo
    ```

#### 安装方式二 Ubuntu20
- 基于 https://github.com/matrix1001/glibc-all-in-one
```
git clone https://github.com/matrix1001/glibc-all-in-one && cd glibc-all-in-one 
git checkout 2661a1d
python3 update_list
cat list
./download 2.36-0ubuntu2_i386
./extract ./deb/libc6_2.36-0ubuntu2_i386.deb /tmp/test
./extract ./deb/libc6-dbg_2.36-0ubuntu2_i386.deb /tmp/test_dbg
./build 2.36 i686
```