---
created_date: 2021-01-08
---

[TOC]

- 参考
  - https://www.ibm.com/developerworks/architecture/library/ar-servgov/?S_CMP=cn-a-wes&S_TACT=105AGX52

# 运维

1. 保障服务正常的运行。
2. 维护好整个技术团队的工作流程。
3. 优化资源配置，节省成本。
4. 性能配置调优，提升用户体验。

## 核心

1. 自动化
   - 解放自己的双手。减少了人力成本，降低了操作风险，提高运维效率
   - 方式：通过工具或者代码
2. 标准化
   - 解放同事的双手。
   - 方式：制定标准统一规范
3. 工程化
   - 解放运维工程师。
   - 方式：封装成一个可高度定制化的运维平台
4. 智能化
   - 解放oncall。
   - 方式：智能预警智能解决

### 内容

01. 发布系统 - Jenkins

    - 自动化发布/蓝绿部署/灰度发布

02. 日志系统 - ELK

03. 监控系统 - Zabbix Prometheus

04. 链路跟踪系统 - skywalking

05. 告警系统 - 无

    - 直接获取告警信息 或 收集数据触发告警
    - 分派告警信息给oncall

06. 服务可观测性 - Grafana

    - 通过日志系统采集到的数据
    - 通过监控系统采集到的数据
    - 通过链路跟踪系统采集到的数据

07. oncall体系（解决告警，处理琐事）

    - 告警复盘--优化告警
    - 琐事复盘--优化琐事

08. 故障转移

    - 节点故障不可以彻底避免，尤其是在低端服务器中
    - 提高故障转移速度，减少对应用的影响

09. 常规演练/灾难演练

    - 潜在危机总有可能发生，平时多演练，当生产环境真正的出现问题时可以更好的从容不迫地面对与迅速解决

10. 资源容量管理

    - 资源使用评估
    - 自动扩容缩容

11. **数据中心**

    - 数据库主从
    - 数据库读写分离
    - 数据库备份
    - 容灾/异地多活

12. 数据仓库

    - 存储海量数据
    - 数据分析

13. 流量限制

    - 限制qps，防止服务无法承受住巨大的流量打击，或者在流量高增长后未完成扩容操作

14. 熔断

    - 将故障的影响降到最低，防止级联故障和雪崩
    - 例如 Redis挂了，应用大面积请求Mysql，导致Mysql也挂了，最后系统崩溃

## 服务治理

- 服务治理是IT治理的一部分，它重点关注服务生命周期的相关要素，包括服务的架构、设计、发布、发现、版本治理、线上监控、线上管控、故障定界定位、安全性等。

### 服务分层

1. 基础设施
   1. 服务器管理
   2. 网络规划
   3. 存储管理
2. 底层服务
   1. 数据库管理
   2. kubernetes平台管理
   3. 中间件管理
3. 应用服务
   1. 业务应用管理
   2. 服务注册与发现

### 服务类型

1. IAAS 基础设施即服务
   - 用户不用自己构建一个数据中心等硬件设施，而是通过租用的方式，利用 Internet从IaaS服务提供商获得计算机基础设施服务，包括服务器、存储和网络等服务。
   1. 云厂商售卖虚拟服务器
   2. Teroform
      - 对接私有云或共有云
      - 实现基础设施管理，基础设施自动扩缩容，基础设施灰度发布
2. PAAS
   - 用户不需要管理与控制云端基础设施（包含网络、服务器、操作系统或存储），但需要控制上层的应用程序部署与应用托管的环境。
   1. 云厂商售卖k8s集群
   2. 日志服务平台
   3. 监控平台
3. SAAS
   - 用户不需要管理基础设施和部署环境，只需要将应用打包为镜像，上传至任何云容器平台上。
   1. Kubernete实现pod的自动扩缩容

### 云原生

- https://thenewstack.io/the-cloud-native-landscape-the-provisioning-layer-explained/

## 运维系统

### 发布系统

- https://blog.csdn.net/qq_42234452/article/details/90906692

1. CI
2. CD
3. 配置更新
4. 数据库更新
   1. yearning SQL审计系统
5. 自动化功能测试/API测试/压力测试

- 部署方式
  1. 蓝绿部署
  2. 滚动发布
     k8s
  3. 灰度发布
     k8s
     envoy

4. 有效利用pre环境
   - 发布pre环境
   - 自动化功能测试、自动化API测试、自动化压力测试
   - 一切ok，上prod环境

### 日志系统

使用ELK

### 监控系统

Zabbix
Prometheus
APM

### 告警系统

- 目的：及时发现系统问题，解决问题，维护稳定优化系统

1. 接收告警信息
2. 发布告警信息
3. 告警看板
4. 告警的抑制

### 服务可观测性

- 1

1. 中间件可观测性
2. 业务模块可观测行

- 2

1. 软件存活状态
2. 软件是否可对外提供服务
3. 软件性能

### oncall体系

1. 解决告警
   1. 确定告警源（来自Prometheus、Zabbix、Kibana、Others）
   2. 确定告警规则
   3. 确定告警数据的获取来源（如果是Kibana触发的，则查看是哪个索引触发的）
   4. 查看告警数据
   5. 分析告警数据 获取触发告警的直接原因
      - 查看当前异常情况
      - 和历史数据进行对比
   6. 解决告警，恢复业务正常
   7. 总结
      - 确定根本性告警原因
      - 是否立刻影响了业务系统的正常运行
      - 是否为可以自动化解决告警

## 项目

1. 拓扑结构图
2. 各个环境配置信息
3. CICD
4. 是否上k8s
5. 服务可观测性
6. 有多少个服务
7. 依赖的外部服务
8. 服务的源码
