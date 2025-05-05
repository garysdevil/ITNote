---
created_date: 2020-11-16
---

[TOC]

## 宏

- https://www.zabbix.com/documentation/3.4/zh/manual/config/macros
- https://www.zabbix.com/documentation/3.4/manual/appendix/macros/supported_by_location
- https://www.cnblogs.com/skyflask/p/7523535.html

## 自动发现

- Discovery rule

1. 写脚本返回json格式的数据

```json
{"data":[{"{#custom_name}":"value1"},{"{#custom_name}":"value12"}]}
```

2. 在web界面配置Discovery rule

3. 在web界面配置Item prototypes

   - 可以使用Discovery rule里返回的变量 item_name\_{#custom_name}[参数1, ${custom_name}]

4. 在web界面配置Trigger prototypes
