## php包管理器composer

1. 列出所有已经安装的包
composer show -i

2. 查看全局安装的包名称和版本：
composer global show

## php demo
```php
<?php
echo '-----PHP INFO-----';
phpinfo();
echo "\n----------获取当前加载php.ini配置文件路径\n";
var_dump(php_ini_loaded_file());  
echo "\n----------如果有另外在加载别的php.ini文件会输出相应的信息,否则输出false\n";
var_dump(php_ini_scanned_files());

echo "\n---动态加载一个扩展-仅对 CLI 环境有效"
dl("skywalking");
echo "\n---查看是否加载了一个扩展";
echo extension_loaded("skywalking");
```
## PHP扩展
1. PECL 是PHP扩展的存储库，提供了所有已知扩展名和目录，用于下载和开发PHP扩展
pecl seatch 扩展名
pecl install skywalking

2. phpize 是用来扩展PHP扩展模块的，通过phpize可以建立PHP的外挂模块

3. autoconf 生成可以自动地配置软件源代码

## php.ini
```conf
extension_dir="" # 定义PHP扩展的文件所在目录
extension=skywalking.so # 要开启的扩展名称
```

## 指令
### php
1. 查看已经加载的扩展
php7.3 -m | grep skywalking

2. 查看扩展加载的目录
php7.3 -i | grep extension_dir

3. 查看php.ini配置文件
php7.3 --ini

4. php查看扩展包的版本信息 
php7.3 --ri 扩展名 

### pecl
1. 查看pecl安装的扩展
pecl  -d php_suffix=7.3 list
-d 当服务器上多个php版本时，指定php版本

2. 查看pecl安装的扩展包位置
pecl  list-files 扩展包名

### phpize
- 参考
https://www.php.net/manual/zh/install.pecl.phpize.php

phpize 命令是用来准备 PHP 扩展库的编译环境的
```bash
cd 扩展名
phpize
./configure
# --with-php-config=/usr/local/php5/bin/php-config5 指定不同版本的php配置
make
make install
# extension=扩展名.so 
```
