## 在mac上制作Windows11启动U盘（M1）
- 参考 
    - https://zhuanlan.zhihu.com/p/23470454
    - https://www.freecodecamp.org/chinese/news/how-make-a-windows-10-usb-using-your-mac-build-a-bootable-iso-from-your-macs-terminal/

1. 下载IOS镜像 https://www.microsoft.com/en-gb/software-download/windows11

2. 格式化
    - 电脑打开后，插入u盘，进入磁盘工具抹除硬盘，并把选择MS—DOS（FAT32）格式，文件名为WIN11（请务必改名，方便后续操作）
    ```sh
        # 或者通过命令行操作
        diskutil list
        diskutil eraseDisk MS-DOS "WIN11" MBR /dev/磁盘设备号
    ```

3. 挂载IOS镜像
    - 双击下载好的iso文件（不会有窗口打开，需要去桌面查看挂载的iso文件），请记住挂载的文件名字，之后需要用到
    ```sh
        # 或者通过命令行操作，使用 hdiutil 指令挂载 Windows 11 文件夹并准备传输
        hdiutil mount ~/Downloads/Win11_22H2_Chinese_Simplified_x64v2.iso
    ```

4. 复制除install.wim文件之外的所有内容到U盘内（install.wim 太大而无法复制到 FAT-32 格式的 USB 驱动器）
   ```sh
        rsync -vha --exclude=sources/install.wim /Volumes/CCCOMA_X64FRE_ZH-CN_DV9/* /Volumes/WIN11
   ```

5. 通过 wimlib 指令复制install.wim文件到U盘内
   ```sh
        # 使用 wimlib 指令
        # 下载 wimlib 指令 brew install wimlib 或者 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        mkdir /Volumes/WIN11/sources
        # wimlib 默认将 install.wim 文件拆分为 2 个小于 4 GB 的文件（以下命令中使用 3.8 GB），然后将它们复制到USB内：
        wimlib-imagex split /Volumes/CCCOMA_X64FRE_ZH-CN_DV9/sources/install.wim /Volumes/WIN11/sources/install.swm 3800

   ```