 1. http 通过traefik连接 dashboard
  ```yaml
    spec:
      containers:
      - args:
        - --entrypoints.web.forwardedheaders.insecure=true
        - --insecureSkipVerify=true # 跳过https验证
  ```

2. 通过设置sticky session保持每次会话只访问一个Pod

ingressroute
```yaml
    - name: AAA
      port: 80
      sticky:
        cookie:
          name: lvl1
```

curl -H "HOST:qa1-api.hub.garys.top"  ${IP1}:30080/util/s -v
```log traefik返回会多出这条数据
Set-Cookie: lvl1=http://${IP2}:8080; Path=/
```
curl -H "HOST:qa1-api.hub.garys.top" -b "lvl1=http://${IP2}:8080" ${IP1}:30080/util/s -v