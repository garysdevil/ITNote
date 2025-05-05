---
created_date: 2023-02-21
---

[TOC]

## 安装ruby
- 文档
    - https://www.runoob.com/ruby/ruby-installation-unix.html
    - https://rvm.io/

1. 方式一 通过linux包管理器安装
    ```bash
    yum install ruby
    ```

2. 方式二 通过RVM版本管理安装ruby
    ```bash
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source /etc/profile.d/rvm.sh 
    # 或 source ~/.rvm/scripts/rvm

    rvm -v
    rvm list known # 列出本地已经安装的ruby版本
    rvm remove 2.5.7
    rvm list
    rvm install 3.2.1 # rvm install 2.6.4 --with-out-ext=fiddle
    rvm 2.5.7 --default
    ```

## ruby包管理器gem
- 安装ruby时会自动安装gem
```
gem install 包名
gem list --local
```

## ruby依赖包版本管理器bundler
```bash
# 安装ruby依赖包版本管理器bundler
gem install bundler
```

## 第一个ruby程序
- vim HelloWorld.rb
```ruby
puts "Hello world"
```
ruby HelloWorld.rb
