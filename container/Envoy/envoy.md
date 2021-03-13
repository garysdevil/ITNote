- 参考
    1. https://github.com/envoyproxy/envoy
    2. https://www.envoyproxy.io/docs/envoy/latest/about_docs

## 概念
- 设计理念：对应用程序而言，网络应该是透明的。当网络或应用程序出现故障时，应当能够很容易确定问题的根源。

### 四个组件
监听器（Listener）：监听器定义了 Envoy 如何处理入站请求，目前 Envoy 仅支持基于 TCP 的监听器。一旦建立连接之后，就会将该请求传递给一组过滤器（filter）进行处理。
过滤器（Filter）：过滤器是处理入站和出站流量的链式结构的一部分。在过滤器链上可以集成很多特定功能的过滤器，例如，通过集成 GZip 过滤器可以在数据发送到客户端之前压缩数据。
路由（Router）：路由用来将流量转发到具体的目标实例，目标实例在 Envoy 中被定义为集群。
集群（Cluster）：集群定义了流量的目标端点，同时还包括一些其他可选配置，如负载均衡策略等。
## 基本使用
1. debug
docker run -d  --name envoy -p 10000:10000 -p 9901:9901 envoyproxy/envoy-debug:v1.16-latest
docker run -d  --name envoy -p 10000:10000 -p 9901:9901 -v /tmp/envoy.yaml:/etc/envoy/envoy.yaml envoyproxy/envoy-debug:v1.16-latest
docker run -d  --name envoy -p 10000:10000 -p 9901:9901 -v /tmp/envoy.yaml:/etc/envoy/envoy.yaml envoyproxy/envoy-alpine:v1.16-latest sh -c -- "envoy -c /etc/envoy/envoy.yaml"

## 配置
- 灰度发布，流量分割 https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_conn_man/traffic_splitting.html?highlight=runtime_fraction

vim envoy.yaml
```yaml
admin:
  access_log_path: /tmp/admin_access.log
  address:
    socket_address:
      protocol: TCP
      address: 0.0.0.0
      port_value: 9901
static_resources:
  listeners:
  - name: listener_0
    address:
      socket_address:
        protocol: TCP
        address: 0.0.0.0
        port_value: 10000
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.config.filter.network.http_connection_manager.v2.HttpConnectionManager
          stat_prefix: ingress_http
          route_config:
            name: local_route
            virtual_hosts:
            - name: local_service
              domains: ["*"]
              routes:
              - match:
                  prefix: "/"
                  runtime_fraction:
                    default_value:
                      numerator: 50
                      denominator: HUNDRED
                    runtime_key: routing.traffic_shift.helloworld
                route:
                  host_rewrite: garys.top
                  cluster: service_garys
              - match:
                  prefix: "/"
                route:
                  host_rewrite: www.baidu.com
                  cluster: service_baidu
          http_filters:
          - name: envoy.filters.http.router

  clusters:
  - name: service_baidu
    connect_timeout: 30s
    type: LOGICAL_DNS
    # Comment out the following line to test on v6 networks
    dns_lookup_family: V4_ONLY
    lb_policy: ROUND_ROBIN
    load_assignment:
      cluster_name: service_baidu
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: www.baidu.com
                port_value: 443
    transport_socket:
      name: envoy.transport_sockets.tls
      typed_config:
        "@type": type.googleapis.com/envoy.api.v2.auth.UpstreamTlsContext
        sni: www.baidu.com
  - name: service_garys
    connect_timeout: 30s
    type: LOGICAL_DNS
    # Comment out the following line to test on v6 networks
    dns_lookup_family: V4_ONLY
    lb_policy: ROUND_ROBIN
    load_assignment:
      cluster_name: service_garys
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: garys.top
                port_value: 80

```
1. host_rewrite：更改 HTTP 请求的入站 Host 头信息


## 热重启包装器-Python
- 脚本 https://github.com/envoyproxy/envoy/blob/release/v1.16/restarter/hot-restarter.py
- 使用方式 https://www.envoyproxy.io/docs/envoy/latest/operations/hot_restarter#operations-hot-restarter
- 优雅关闭 https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/operations/draining

- python /hot-restarter-1.16.py /start_envoy.sh

- 信号
  1. SIGTERM：将干净地终止所有子进程并退出。
  2. SIGHUP：将重新调用作为第一个参数传递给热重启程序的脚本，来进行热重启。
  3. SIGCHLD：如果任何子进程意外关闭，那么重启脚本将关闭所有内容并退出以避免处于意外状态。随后，控制进程管理器应该重新启动重启脚本以再次启动Envoy。
  4. SIGUSR1：将作为重新打开所有访问日志的信号，转发给Envoy。可用于原子移动以及重新打开日志轮转
### 生成镜像
```Dockerfile
FROM envoyproxy/envoy-alpine:v1.16-latest as envoy

COPY hot-restarter-1.16.py start_envoy.sh /
RUN chmod +x  /start_envoy.sh && echo 'kill -HUP 1' > /restart.sh && apk update python2 && apk add python2 --no-cache
ENTRYPOINT [ "python2", "/hot-restarter-1.16.py", "/start_envoy.sh" ]
```
### 相关参数
1. --drain-time-s <integer> Defaults to 600 seconds (10 minutes)
设置排空连接的时间

2. --parent-shutdown-time-s <integer> Defaults to 900 seconds (15 minutes).
设置热重启时关闭parent process的等待时间

## 配置检查工具
1. 安装bazel来编译检查工具  
https://docs.bazel.build/versions/3.7.0/getting-started.html  

2. 编译生成检查工具
```bash
bazel build //test/tools/config_load_check:config_load_check_tool  
bazel-bin/test/tools/config_load_check/config_load_check_tool ${PATH}
```