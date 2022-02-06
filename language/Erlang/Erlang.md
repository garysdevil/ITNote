

## 相关链接
- OTP框架 https://github.com/erlang/otp
- Erlang编译工具安装 https://www.erlang-solutions.com/downloads/
- Rebar3 https://github.com/erlang/rebar3


## Erlang（Ericsson Language）
- 定义：是一种通用的面向并发的动态类型编程语言，它由瑞典电信设备制造商爱立信所辖的CS-Lab开发，目的是创造一种可以应对大规模并发活动的编程语言和运行环境。
- 诞生：问世于1987年，于1998年发布开源版本。
- 运行时环境：一个名字为BEAM的虚拟机。
- 特性：并发性、分布式、脚本语言...

- OTP（Open Telecom Platform）
    - 是一组Erlang库，包含：Erlang运行时系统、主要由Erlang编写的组件、一组Erlang程序设计原则。
    - 是爱立信公司开发的开放电信应用平台，这是一个很强大并且很通用的框架，可以帮助开发者编写大型的、容错的，分布式的系统。

- Rebar3 是一个Erlang工具，可以轻松地创建、开发和发布Erlang库、应用程序和系统。

### 一
- epmd 
    - Erlang Port Mapper Daemon
    - epmd完成Erlang节点和IP,端口的映射关系
## Elixir
- Elixir 
    - 是一个基于 Erlang 虚拟机的函数式、面向并行的通用编程语言。
    - 以 Erlang 为基础，支持分布式、高容错、实时应用程序的开发，同时亦对其进行扩展使之借助宏实现元编程，并通过协议支持多态。

- Mix
    - 是Elixir工程的构建工具。

- ExUnit 是Elixir的一个基本单元测试框架。


## 安装相关工具

- 安装erlang
    ```bash
    # centos上在线安装
    wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
    rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
    yum install -y erlang

    # Ubuntu20离线安装
    wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_24.2-1~ubuntu~focal_amd64.deb
    apt install -y ./esl-erlang_24.2-1~ubuntu~focal_amd64.deb
    apt-get install erlang

    # 安装成功后查看eshell版本
    erl -version

    # 查看erl的版本
    erl
    ```

- Rebar3
```bash
wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
```

- 安装elixir
    ```bash
    # elixir # 安装成功后进行验证 elixir -v # Elixir 1.12.3
    cd /
    wget https://github.com/elixir-lang/elixir/releases/download/v1.12.3/Precompiled.zip
    unzip Precompiled.zip -d
    ```

## 指令
- erl
    ```bash
    # 启动一个eshell节点并且随机映射一个端口
    erl -name test1@gary -setcookie 1234
    # 启动时候启动选项包含-name 或者-sname就会自动启动epmd;

    # 查看节点和IP,端口的映射关系,epmd进程的默认端口为4369
    epmd -names
    # 让epmd只侦听指定的IP   
    ERL_EPMD_ADDRESS=127.0.0.1 ERL_EPMD_PORT=8384 epmd -daemon
    epmd -address 127.0.0.1 -port 8384
    ```

- mix
    ```bash
    mix new kv --module KV
    ```

- rebar3
    ```bash
    # rebar3为每种类型的项目都提供了模板，通过以下指令使用。
    rebar3 new ${template} ${project_name}
    # template的取值：
    # app: 一个有监督树、有状态的OTP应用程序，是一个单应用程序
    # lib: 一个OTP依赖(无监督树)，与其他模块联合使用，是一个单应用程序
    # release: 创建一个大型项目
    # escript: 一个特殊格式的单应用项目，可以编译为一个可执行的脚本程序
    # plugin: rebar3插件结构

    # 编译运行程序
    rebar3 shell

    # 将程序进行编译打包成prod版本的tar文件
    rebar3 as prod tar
    # 可运行程序 _build/prod/rel/${project_name}/bin/project_name
    # 程序被打包后的地址 ss_build/prod/rel/${project_name}/${project_name}-0.1.0.tar.gz
    ```

## 语法
### hello world
- 参考 https://riptutorial.com/erlang/example/3599/hello-world

- hello脚本 vi hello.erl
    ```erlang
    -module(hello). % 定义模块名为hello，必须和文件名相同
    -export([hello_world/0]). % 暴露hello_world，函数需要传递0个参数进来

    hello_world() ->
    io:format("Hello, World!~n", []).
    ```
- erl 使用eshell编译运行脚本
    - 输入 erl 进入eshell
    ```erlang
    1> c(hello). % 加载hello.erl文件并进行编译生成字节码文件hello.beam
    {ok,hello}
    2> hello:hello_world(). % 执行模块内的函数
    Hello, World!
    ok
    ```

- erlc 使用erlc编译脚本
    ```bash
    erlc hello.erl -o hello.beam
    ```

- 语法
    1. Erlang注释符是百分号 %
    2. 使用点作为语句结束的标识
    3. 函数内，最后一个计算结果将被返回

### 其它
- sasl是一个应用，sasl的一个重要功能便是可以记录系统进程相关日志，如进程启动、结束、崩溃错误等信息。sasl的日志功能是基于erlang自带的日志模块error_logger来实现的。
    ```eshell
    application:start(sasl).
    ```