# 以太坊区块链游览器 Blockscout
- 相关链接
    - https://github.com/syscoin/blockscout/blob/master/Dockerfile
    - https://github.com/asdf-vm/asdf-elixir
- 参考
    - https://www.jianshu.com/p/40bbc588058f
    - https://docs.blockscout.com/for-developers/information-and-settings/requirements

## 构建
```
docker build --no-cache --network=host -f Dockerfile -t garysdevil/blockscout:latest .
```

## Deploy
- 部署postgres
    ```bash
    # https://hub.docker.com/_/postgres?tab=description
    docker pull postgres:13
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
    docker run --rm --network=host --env-file blockscout.env garysdevil/blockscout:latest mix do ecto.drop, ecto.create, ecto.migrate
    docker run -d --network=host --env-file blockscout.env --name blockscout garysdevil/blockscout:latest
    # 
    ```