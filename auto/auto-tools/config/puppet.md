---
created_date: 2024-11-19
---

[TOC]

# puppet
- 参考文档
https://www.cnblogs.com/along21/p/10369858.html
## 总览
1. 名词解释
资源：是puppet的核心，通过资源申报，定义在资源清单中。相当于ansible中的模块，只是抽象的更加彻底。
类：一组资源清单。相当于ansible的剧本。
模块：包含多个类。相当于ansible中的角色。
站点清单：以主机为核心，应用哪些模块。 

资源清单manifest：puppet的程序文件，以.pp作为文件名后缀

2. master/agent模型
agent每隔30分钟请求master，master将此服务器的所有资源清单处理为catalog然后发送给agent，agent执行对应操作来满足期望的状态，agent生成对应的报告信息发送给master。
3. agent模式
## 指令
```bash
puppet module list  # 列出所有的模块
puppet --configprint modulepath  # 模块的存放位置
puppet module search Module_Name  # 搜索模块
puppet module install Module_Name  # 安装模块
puppet describe -l  # 列出所有资源
```
## 实践学习
### 语法
```ruby
key => value # 定义一个值
key +> value # 添加一个值
```
### 单机简单使用
1. 编写资源清单,使用group资源创建用户组
vim group.pp
```ruby
group{'mygrp':
        name => 'mygrp',
        ensure => present, # 资源的目标状态
        gid => 2000,
}
```
```bash
--noop # 运行catelog,但不执行配置
# 预执行一次，检查是否有语法错误
puppet apply -v --noop group.pp
# 执行
puppet apply -v group.pp
# 验证
cat /etc/group |grep mygrp
```
2. 依赖关系
vim user2.pp
```ruby
# 被依赖的类型的首字母必须大写
group{'redhat':
        ensure => present,
#       before => User['ilinux'],  # 方案1
}

user{'ilinux':
        ensure => present,
        comment => "ilinux.io",
        groups => 'redhat',
        require => Group['redhat'],   # 方案2
}

# Group['redhat'] -> User['ilinux']   # 方案3
``` 

3. 通知关系：通知相关的其它资源进行“刷新”操作
vim srv3.pp
```ruby
package{'redis':
        ensure => installed,
}

file{'/etc/redis.conf':
        ensure  => file,
        source  => '/root/manifest/files/redis.conf',
        owner   => 'redis',
        group   => 'root',
        mode    => '0640',
#     notify    => Service['redis']
}

service{'redis':
        ensure  => running,
        enable  => false,
        hasrestart => true,
#     subscribe => File['/etc/redis.conf']
}

Package['redis'] -> File['/etc/redis.conf'] ~> Service['redis']
```

4. tag 标签
```ruby
type{'title':
　　...
　　tag => ['TAG1','TAG2',...],
}
```
puppet apply --tags TAG1,TAG2,... FILE.PP

### 类
#### 声明
1. 使用include（常用）
include base::linux,apache 可以用逗号隔开声明多个类
2. 使用require
3. 像声明一个资源一样声明类（常用）
4. 使用ENC的风格来声明一个类
### 类的定义与调用
1. 类的名称只能以小写字母开头，可以包含小字字母、数字和下划线。
2. 每个类都会引入一个新的变量scope ，这意味着在任何时候访问类中的变量时，都得使用其完全限定名称。

3. 不带参数的类 
vim class1.pp
```ruby
class class1{
    group{'mygrp':
            name => 'mygrp',
            ensure => present, # 资源的目标状态
            gid => 2000,
    }
}

class redis {		# 定义一个类
    package{'redis':
        ensure  => installed,
    }   ->

    file{'/etc/redis.conf':
        ensure  => file,
        source  => '/root/manifests/file/redis.conf', # 自定义的redis配置文件
        owner   => 'redis',
        group   => 'root',
        mode    => '0640',
        tag     => 'redisconf'
    }   ~>

    service{'redis':
        ensure  => running,
        enable  => true,
        hasrestart  => true,
        hasstatus   => true
    }
}
include class1,redis	# 调用类 方式1
```
4. 带参数的类
```ruby
class createfile($filename='/home/vagrant/puppet/test.txt') {
    file{"$filename":
        ensure => file,
        content => "How are you?\nHow old are you?\n",
        # owner => 'root',
        # group => 'root',
        mode => '0600'
    }
}

class{"createfile":			# 调用类 方式2
    filename    => '/home/vagrant/puppet/memcached', # 给参数传入值
}
include createfile
```

5. 类的继承
```ruby
class createfile1 {
    file{'/home/vagrant/puppet/file1.txt':
        ensure => file,
        content => "How are you?\nHow old are you?\n",
        # owner => 'root',
        # group => 'root',
        mode => '0600'
    }
    service{'mysql':
        ensure  => running,
        enable  => true,
    }
}
class createfile2 inherits createfile1 {
    file{'/home/vagrant/puppet/file2.txt':
        ensure => file,
        content => "How are you?\nHow old are you?\n",
        mode => '0600'
    }
    File['/home/vagrant/puppet/file2.txt'] {	    # 定义依赖关系
        subscribe   => File['/home/vagrant/puppet/file1.txt']
    }
    Service['mysql'] {						# 定义依赖关系
        subscribe   => File['/home/vagrant/puppet/file1.txt']
    }
}
class{"createfile":			# 调用类 方式2
}
```

### 模板
<%= EXPRESSION %> — 插入表达式的值，进行变量替换
<% CODE %> — 执行代码，但不插入值
<%# COMMENT %> — 插入注释
<%% or %%> — 插入%

vim redis.conf.erb
```erb
aaaaaaa
bind 127.0.0.1 <%= @ipaddress_eth0 %>
```
vim file.pp
```ruby
file{'/home/vagrant/puppet/redis.conf':
    ensure  => file,
    content => template('/home/vagrant/puppet/redis.conf.erb'),		# 调用模板文件
}
```

### 模块
