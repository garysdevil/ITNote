---
created_date: 2020-11-30
---

[TOC]

## 在一台服务器上，通过多个不同公网IP访问互联网的实现方式

### aws方式

https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI

1. 不同的实例类型 可以绑定的网卡数量不一样，每张网卡可以绑定的私有ip地址(辅助ip)也不一样。
2. t2.medium 类型的实例：最多可以绑定3张网卡，每张网卡最多有6个私有ip地址。
3. 一个外部IP可以关联一个私有IP。

### google方式

https://cloud.google.com/vpc/docs/create-use-multiple-interfaces 多接口
https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/networking/using-multiple-ip-addresses?hl=zh-cn 别名IP
https://cloud.google.com/compute/docs/protocol-forwarding 协议转发

1. 只有在创建实例时才可以创建网络接口
2. 在单个实例中配置的每个网络接口都必须连接到不同的 VPC 网络
3. 可为每个虚拟机实例配备 1-8 个网络接口。每个实例可以配置的网络接口 取决于 有多少个VPC网络 和 实例本身的CPU数。每个接口对应一个外部 IP 地址.
4. 一个接口可以有多个别名IP（私有IP）-- （服务器内执行指令ip a，别名IP不会显示）。
5. 可以通过申请多个外部IP地址，然后通过协议转发到某个实例上。 在实例上可以监听被转发过来的IP:PORT。
