- 参考
    1. https://github.com/envoyproxy/envoy
    2. https://www.envoyproxy.io/docs/envoy/latest/about_docs

## 概念
- 设计理念：对应用程序而言，网络应该是透明的。当网络或应用程序出现故障时，应当能够很容易确定问题的根源。
## 简单使用
1. debug
docker run -d  --name envoy -p 10000:10000 -p 9901:9901 envoyproxy/envoy-debug:v1.16-latest
docker run -d  --name envoy -p 10000:10000 -p 9901:9901 -v /tmp/envoy.yaml:/etc/envoy/envoy.yaml envoyproxy/envoy-debug:v1.16-latest
docker run -d  --name envoy -p 10000:10000 -p 9901:9901 -v /tmp/envoy.yaml:/etc/envoy/envoy.yaml envoyproxy/envoy-debug:v1.16-latest sh -c -- "whoami && envoy -c /etc/envoy/envoy.yaml --restart-epoch $RESTART_EPOCH"


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