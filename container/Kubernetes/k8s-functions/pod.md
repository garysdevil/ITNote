---
created_date: 2021-01-13
---

[TOC]

## pod重启的原因

1. POD正常退出
2. POD异常退出
3. POD使用从CPU超过POD yaml里设置的CPU上限,或者超过容器所在namespace里配置的CPU上限
4. POD使用从Mem超过POD yaml里设置的Memory上限,或者超过容器所在namespace里配置的Memory上限
5. 运行时宿主机的资源无法满足POD的资源(内存 CPU)时会自动调度到其他机器,也会出现重启次数+1
6. 创建POD时指定的image找不到或者没有node节点满足POD的资源(内存 CPU)需求,会不断重启
