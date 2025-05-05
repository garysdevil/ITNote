---
created_date: 2020-11-30
---

[TOC]

- 参考
    - https://github.com/Kong/kong  
    - https://docs.konghq.com/2.2.x/configuration/
- Kong
是由Mashape公司开源的，基于Nginx的API gateway
- 功能
    - 外部流量的路由转发
    - 授权、日志、ip限制、限流、api 统计分析（存在商业插件Galileo等、也可自己研发）、请求转化、跨域（CORS）、其它功能通过lua编写插件实现

## 安装 kong
- 默认端口
    1. 8000 请求进入端口，kong根据配置的规则转发到真实的后台服务地址。
    2. 8443 请求进入端口
    2. 8001 管理端口，插件设置、API的增删改查、以及负载均衡等一系列的配置都是通过8001端口进行管理。
### docker安装
- 参考
https://hub.docker.com/_/kong/

```
docker network create kong-net
```
```bash
docker run -d --name kong-database \
-e "POSTGRES_DB=kong" \
-e "POSTGRES_USER=kong" \
-e "POSTGRES_PASSWORD=password" \
-v "/opt/data1/kong/dbdata:/var/lib/postgresql/data" \
-p "5432:5432"  \
postgres:9.6

# default port 5432
```
```bash
docker run --rm \
    --link kong-database:kong-database \
    -e "KONG_PG_PASSWORD=kong" \
    -e "KONG_PG_USER=kong" \
    -e "KONG_PG_PASSWORD=password" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    kong kong migrations bootstrap
```
```bash
docker run -d --name kong \
    --link kong-database:kong-database \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_USER=kong" \
    -e "KONG_PG_PASSWORD=password" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong

# reload Kong
docker exec -it kong kong reload
```

### docker/docker-compose 安装
https://github.com/Kong/docker-kong/tree/master/compose

### k8s安装
- 参考
    - https://docs.konghq.com/2.2.x/kong-for-kubernetes/install/
1. Kong Ingress Controller 将 Kubernetes Ingress 资源对象的路由规则转化成kong的实际配置。
2. kong proxy


## kong使用
### API
- 参考
https://docs.konghq.com/2.0.x/admin-api/
```bash
# 查看所有的插件
curl http://localhost:8001/plugins/ | python -m json.tool
# 删除一个插件
curl  http://localhost:8001/plugins/${plugin-id} -XDELETE

# 列出所有证书
curl  http://localhost:8001/certificates | python -m json.tool
# 查看某个证书
curl  http://localhost:8001/certificates/${certificate-id} | python -m json.tool
# 删除证书
curl  http://localhost:8001/certificates/${ca_certificate id} -XDELETE

# 查看hostname和证书的对应关系
curl  http://localhost:8001/snis | python -m json.tool
```
## 安装UI konga
1. 安装
```bash
dbhost=db
dbpass=kongroot
dbuser=kong
dbname=konga
uipass=123456
dockernet=kong_kong-net

docker run -p 1337:1337 \
    --network ${dockernet} \
    -e "TOKEN_SECRET=${uipass}" \
    -e "DB_ADAPTER=postgres" \
    -e "DB_HOST=${dbhost}" \
    -e "DB_PORT=5432" \
    -e "DB_USER=${dbuser}" \
    -e "DB_PASSWORD=${dbpass}" \
    -e "DB_DATABASE=${dbname}" \
    -e "DB_PG_SCHEMA=public"\
    --name konga \
    pantsel/konga

    # -e "NODE_ENV=production" \  # 如果使用生产模式，则不会自动创建数据库内的任何内容
```
2. web界面配置
连接kong的管理端口。