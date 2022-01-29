
## Erlang（Ericsson Language）
- 定义：是一种通用的面向并发的动态类型编程语言，它由瑞典电信设备制造商爱立信所辖的CS-Lab开发，目的是创造一种可以应对大规模并发活动的编程语言和运行环境。
- 诞生：问世于1987年，于1998年发布开源版本。
- 运行时环境：一个名字为BEAM的虚拟机。
- 特性：并发性、分布式、脚本语言...

## Erlang 生态
- Elixir 是一个基于 Erlang 虚拟机的函数式、面向并行的通用编程语言。Elixir 以 Erlang 为基础，支持分布式、高容错、实时应用程序的开发，同时亦对其进行扩展使之借助宏实现元编程，并通过协议支持多态。

- OTP（Open Telecom Platform）
    - 是一组Erlang库，包含：Erlang运行时系统、主要由Erlang编写的组件、一组Erlang程序设计原则。
    - 是爱立信公司开发的开放电信应用平台，这是一个很强大并且很通用的框架，可以帮助开发者编写大型的、容错的，分布式的系统。

- Mix 是Elixir装载的一个构建工具，提供了创建、编译、测试应用、管理依赖等等。

- ExUnit 是Elixir装载的一个基本单元测试框架。

## 安装相关工具
- 参考 
    - https://www.erlang-solutions.com/downloads/

- 安装erlang
    ```bash
    # 安装成功后进行验证
    erl -version

    # centos上安装
    wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
    rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
    yum install -y erlang

    # Ubuntu20安装
    wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_24.2-1~ubuntu~focal_amd64.deb
    apt install ./esl-erlang_24.2-1~ubuntu~focal_amd64.deb
    apt-get install erlang

    ```

- 安装elixir
    ```bash
    # elixir # 安装成功后进行验证 elixir -v # Elixir 1.12.3
    cd /
    wget https://github.com/elixir-lang/elixir/releases/download/v1.12.3/Precompiled.zip
    unzip Precompiled.zip -d
    ```

## 基本语法
```Elixir
mix new kv --module KV
```