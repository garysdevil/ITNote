## php依赖管理器composer
- Composer 不是一个包管理器。是的，它涉及 "packages" 和 "libraries"，但它在每个项目的基础上进行管理，在你项目的某个目录中（例如 vendor）进行安装。默认情况下它不会在全局安装任何东西。因此，这仅仅是一个依赖管理。
1. 安装composer
```bash
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# 切换为国内镜像
composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 更新 composer
composer selfupdate
```
2. 列出所有已经安装的包
composer show -i

3. 查看全局安装的包名称和版本：
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

echo "\n---动态加载一个扩展-仅对 CLI 环境执行时有效"    
dl("skywalking");

echo "\n---查看是否加载了一个扩展";
echo extension_loaded("skywalking");
```
## PHP扩展
### 开发扩展
- 参考
https://learnku.com/articles/8237/1-my-first-php-extension
https://xz.aliyun.com/t/4214  
https://segmentfault.com/a/1190000007590422
https://www.jianshu.com/p/3edbbb6bb49e 按照这个方法
#### 实例一
1. git clone https://github.com/php/php-src
2. cd ext
3. 使用ext_skel生成扩展框架(php7.3之后ext_skel变成了ext_skel.php)
./ext_skel --extname=hello  
4. 解注释 vim config.m4 
```m4
PHP_ARG_ENABLE(hello, whether to enable hello support,
Make sure that the comment is aligned:
[  --enable-hello           Enable hello support])
```
5. 编译
phpize 
./configure --enable-hello
make
make install

5. 验证扩展是否编译成功
以上命令执行后，会在扩展目录生成hello.php的测试文件，测试文件包含了 动态的方式加载扩展进行测试
php -d enable_dl=On hello.php

#### 实例二 在扩展里添加一个函数
1. 更改扩展代码 vim hello.c
```php
const zend_function_entry hello_functions[] = {
        PHP_FE(confirm_hello_compiled,  NULL)           /* For testing, remove later. */
        PHP_FE(hello_world,  NULL)  // 添加一个新的扩展函数
        PHP_FE_END      /* Must be the last line in hello_functions[] */
};

// 新的扩展函数的具体实现
PHP_FUNCTION(hello_world)
{
        php_printf("Hello World!\n");
        RETURN_TRUE;
}
```
2. 编译
```bash
phpize 
./configure --enable-hello
make  # 会在modules文件夹下生成hello.so
make install
```
3. 验证扩展是否编译成功
php -d enable_dl=On hello.php

4. 向php配置文件中添加扩展
vim php.ini
extension = hello.so

5. 验证扩展
php -a
hello_world();

#### 实例三 在扩展里添加一个钩子
vim hello.c 
```php
PHP_MINIT_FUNCTION(hello)
{
        /* If you have INI entries, uncomment these lines
        REGISTER_INI_ENTRIES();
        */
        zend_set_user_opcode_handler(ZEND_ECHO, ppecho); // 在调用php代码前添加一个钩子ppecho
        return SUCCESS;
}

// 钩子ppecho的具体实现
int ppecho(ZEND_OPCODE_HANDLER_ARGS)
{
        php_printf("hook success");
        // return ZEND_USER_OPCODE_RETURN; // 停止往下执行
        return ZEND_USER_OPCODE_DISPATCH; // 继续往下执行
}

```
### 管理扩展
1. PECL 是PHP扩展的存储库，提供了所有已知扩展名和目录，用于下载和开发PHP扩展
pecl seatch 扩展名
pecl install skywalking

2. phpize 是用来扩展PHP扩展模块的，通过phpize可以建立PHP的外挂模块

3. autoconf 生成可以自动地配置软件源代码

## 配置
- php-fpm.conf是PHP-FPM特有的配置文件（有的PHP版本的配置文件路径中是/fpm.d/www.conf）
- php.ini是php模式中必须的配置文件

- php-fpm.conf是PHP-FPM进程管理器的配置文件，php.ini是PHP解析器的配置文件

### php.ini
```conf
extension_dir="" # 定义PHP扩展的文件所在目录
log_errors = On # 将错误日志记录进文件内
error_log = /proc/self/fd/2 # 错误日志记录的文件位置
# error_log = syslog # 指定产生的错误报告写入操作系统的日志里  
display_errors = Off # 不将错误正常返回
extension=扩展名.so  # 添加扩展
```
### php-fpm.conf
```conf
# 配置慢日志
slowlog = /usr/local/var/log/php-fpm.log.slow
request_slowlog_timeout = 5s
```
## 指令
### php
1. 查看已经加载的扩展
php7.3 -m | grep skywalking

2. 查看扩展加载的目录
php7.3 -i | grep extension_dir

3. 查看php.ini配置文件路径
php7.3 --ini

4. php查看扩展包的版本信息 
php7.3 --ri 扩展名 

5. 动他加载一个扩展
php -d enable_dl=On hello.php
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

## PHP7 代码执行过程
1. PHP 代码
2. Scanning（Lexing）词法分析，将PHP代码转换为语言片段（Tokens）
3. Parsing语法分析,生成抽象语法树（AST - Abstract Syntax Tree）
4. 将语法树转为 Opcodes（PHP的中间代码）
5. Zend VM的执行单元调用对应的C函数执行Opcodes代码
