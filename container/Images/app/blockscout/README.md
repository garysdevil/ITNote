# 以太坊区块链游览器 Blockscout

- 官方链接
    - https://github.com/blockscout/blockscout
    - https://docs.blockscout.com/for-developers/information-and-settings/requirements
- 第三方参考
    - https://www.jianshu.com/p/40bbc588058f
- 相关链接
    - https://github.com/syscoin/blockscout/blob/master/Dockerfile
    - https://github.com/asdf-vm/asdf-elixir

## 构建
```bash
# 方式一 构建指定的commit分支
docker build --build-arg blockscout_commit=v4.1.0-beta --no-cache --network=host -f Dockerfile -t garysdevil/blockscout:v4.1.0-beta .
# 方式二 构建master分支
docker build --no-cache --network=host -f Dockerfile -t garysdevil/blockscout:latest .
```

## 部署
- 部署postgres
    ```bash
    # https://hub.docker.com/_/postgres?tab=description
    docker pull postgres:13

    # docker volume create postgres-volumn
    # -v postgres-volumn:/var/lib/postgresql/data
    docker run -d --name postgres -p 127.0.0.1:5432:5432 -e POSTGRES_PASSWORD=postgres postgres:13
    # docker exec -it postgres /bin/bash
    # psql -h 127.0.0.1 -U postgres -W
    ```

- 配置blockscout的环境变量
    - vi blockscout.env
    ```conf
    DATABASE_URL=postgresql://postgres:postgres@localhost:5432/blockscout
    DB_HOST=localhost
    DB_PASSWORD=postgres
    DB_PORT=5432
    DB_USERNAME=postgres
    ETHEREUM_JSONRPC_VARIANT=geth
    ETHEREUM_JSONRPC_HTTP_URL=http://localhost:8545
    ETHEREUM_JSONRPC_WS_URL=ws://localhost:8544
    SUBNETWORK=PRIVATE
    PORT=4000
    ```

- 部署blockscout
    ```bash

    docker pull garysdevil/blockscout:latest

    # 初始化数据库
    docker run --rm --network=host --env-file blockscout.env garysdevil/blockscout:latest mix do ecto.drop, ecto.create, ecto.migrate
    # 启动服务
    docker run -d --network=host --env-file blockscout.env --name blockscout garysdevil/blockscout:latest
    ```
- 访问方式
    - http://127.0.0.1:4000
    - https://127.0.0.1:4001


# Elixir语言
## 相关工具
- Erlang（Ericsson Language）
    - 是一种通用的面向并发的动态类型编程语言，它由瑞典电信设备制造商爱立信所辖的CS-Lab开发，目的是创造一种可以应对大规模并发活动的编程语言和运行环境。
    - 问世于1987年，于1998年发布开源版本。
    - Erlang运行时环境是一个虚拟机（BEAM）。
    - 特性：并发性、分布式、脚本语言...

- Elixir 是一个基于 Erlang 虚拟机的函数式、面向并行的通用编程语言。Elixir 以 Erlang 为基础，支持分布式、高容错、实时应用程序的开发，同时亦对其进行扩展使之借助宏实现元编程，并通过协议支持多态。

- OTP（Open Telecom Platform）是爱立信公司开发的开放电信应用平台，这是一个很强大并且很通用的框架，包含了一系列的库，可以帮助开发者编写大型的、容错的，分布式的系统。

- Mix 是Elixir装载的一个构建工具，提供了创建、编译、测试应用、管理依赖等等。

- ExUnit 是Elixir装载的一个基本单元测试框架;

## 基本语法
```Elixir
mix new kv --module KV
```