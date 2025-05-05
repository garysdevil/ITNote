---
created_date: 2020-11-16
---

[TOC]

1. jenkins集成k8s
```
安装jenkins的kubernetes cli插件

找到kubernetes集群kubectl命令的配置文件，一般为~/.kube/config

找到里面的两个证书信息client-certificate-data和client-key-data，反解为证书

echo "${client-certificate-data}" | base64 -d > admin.pem

echo "${client-key-data}" | base64 -d > admin-key.pem

生成p12文件：(会要求输入密码，自己指定一个即可)

openssl pkcs12 -inkey admin-key.pem -in admin.pem -export -out Cert.p12

在jenkins里选择凭证，创建新的凭证（类型为Certicate）


密码填写生成p12文件时输入的密码。

使用pipeline调用

withKubeConfig([credentialsId: 'qa-120',
serverUrl: 'https://${IP}:8443',
contextName: 'k8s-qa'])

以上credentialsId为jenkins中的凭证ID

serverUrl为kube-api的地址

```