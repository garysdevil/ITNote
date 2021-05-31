# aws
## 服务与术语
- 基本服务
  1. EC2 
    - 虚拟服务器 https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html
  2. IAM 
    - Identity and Access Management
    - 身份识别和权限认证 https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html
  3. VPC 
    - Virtual Private Cloud
    - 虚拟私有网络 https://docs.aws.amazon.com/zh_cn/vpc/latest/userguide/what-is-amazon-vpc.html
  3. VPC Peering Connection
    - VPC对等连接 https://docs.aws.amazon.com/zh_cn/vpc/latest/peering/working-with-vpc-peering.html
  4. SES 
    - 简单邮箱服务 https://docs.aws.amazon.com/ses/latest/DeveloperGuide/Welcome.html
  5. Amazon ES 
    - Amazon ElasticSearch 
    - 存储与搜索引擎 https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/what-is-amazon-elasticsearch-service.html
  6. ElastiCache for Redis
    redis缓存服务 https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html
  7. EKS
    Amazon版的k8s https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html
  8. ECR
    - Amazon Elastic Container Registry
    - https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html
  9. ECS
    - Amazon Elastic Container Service
    - 一种高度可扩展的快速容器管理服务, 易于在群集上运行、停止和管理容器。 
    - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html
  10. S3
    - 对象存储 https://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html
  11. kafka服务 MSK(Kafka):
    - Amazon Managed Streaming for Apache Kafka
    - Kafka服务 https://docs.aws.amazon.com/msk/latest/developerguide/what-is-msk.html
  12. CloudFormation
    - 基础架构即代码服务 https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html
  13. CloudFront
    - AWS的CDN服务 https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html
  14. Lambda
    - serverless计算  https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
  15. AWS CLI
    - AWS Command Line Interface  在本地Shell 中使用命令与 AWS 服务进行交互
    - https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
    - https://docs.aws.amazon.com/cli/latest/reference/
  16. Route 53
    - DNS服务 https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html
  18. RDS
    - 关系型数据库服务 https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html
  19. EMR
    - 大数据处理服务 https://docs.aws.amazon.com/emr/index.html
  20. AWS Trusted Advisor
    - 资源服务的成本、性能、安全优化指导 https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-reservation-models/aws-trusted-advisor.html
  21. ACM
    - AWS Certificate Manager 
    - 证书管理  https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html
  22. Fargate
    - 当创建ECS、EKS时可以选择Fargate作为资源提供方。
    - 提供CPU和内存: https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/userguide/what-is-fargate.html

  23. ELB: CLB NLB ALB
    - 负载均衡服务 https://aws.amazon.com/elasticloadbalancing/features/?nc1=h_ls

  24. emr
    - 大数据平台 https://docs.aws.amazon.com/emr/index.html

- Advanced
  1. AWS 架构中心 
    - https://aws.amazon.com/cn/architecture/?solutions-all.sort-by=item.additionalFields.sortDate&solutions-all.sort-order=desc&whitepapers-main.sort-by=item.additionalFields.sortDate&whitepapers-main.sort-order=desc&reference-architecture.sort-by=item.additionalFields.sortDate&reference-architecture.sort-order=desc
  2. AWS 架构完善 
    - https://aws.amazon.com/cn/well-architected-tool/
  3. AWS Cost Explorer Service
    - 账单和成本管理 https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/Welcome.html

- 术语
  1. CloudWatch： AWS资源服务的监控报警可视化中心
  2. AMI: Amazon Machine Image
  3. ARN： AWS资源的唯一标识 https://docs.aws.amazon.com/zh_cn/general/latest/gr/aws-arns-and-namespaces.html
    - 示范 arn:partition:service:region:account-id:resource-type:resource-id

## Amazon Stack和Cloudformation
- 参考文档 
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html 堆栈是什么
https://www.cnblogs.com/pourrire/p/10042308.html Cloudformation是什么
https://docs.aws.amazon.com/zh_cn/AWSCloudFormation/latest/UserGuide/template-anatomy.html 如何编写Cloudformation模板

### stack
1. 功能
  堆栈可以作为单个单元 来管理的一系列 AWS 资源。

2. 使用stack的方式
  AWS CloudFormation控制台、 API 或 AWS CLI 


### cloudformation
1. 概念
  - AWS cloudformation是一项典型的（IAC）基础架构即代码服务。
  - 通过编写 模板 操作 堆栈 对亚马逊云服务的资源进行调用和编排。

#### CloudFormation template
1. 概念
  1. 是一个 JSON 或 YAML 格式的文本文件，该文件描述 AWS 基础设施，用来创建 堆栈。
  2. 包含9个主要部分。Resources 部分是唯一的必需部分。

2. 模板中的某些部分可以任何顺序显示。但是，在构建模板时，使用以下列表中显示的逻辑顺序可能会很有用，因为一个部分中的值可能会引用上一个部分中的值。
```conf
{
  "AWSTemplateFormatVersion" : "version date",

  "Description" : "JSON string",

  "Metadata" : {
    template metadata
  },

  "Parameters" : {
    set of parameters
  },

  "Mappings" : {
    set of mappings
  },

  "Conditions" : {
    set of conditions
  },

  "Transform" : {
    set of transforms
  },

  "Resources" : {
    set of resources
  },

  "Outputs" : {
    set of outputs
  }
}
```

3. 函数 json格式
Fn::GetAtt 获取资源的附加属性
Fn::Join 构建值
Ref  获取参数值

## Amazon ELB
- 参考
https://aws.amazon.com/cn/blogs/china/aws-alb-route-distribute/ 配置ALB与NLB
      
1. ALB  --  Application Load Balancer 
7层负载均衡，可以通过url转发到不同的目标群组
ALB负载均衡器 https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
ALB入口控制器 https://aws.amazon.com/cn/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/

2. NLB  --  Network Load Balancer
4层负载均衡

3. CLB  --  Classic Load Balancer
将连接请求分发到不同的EC2上

## Amazon CLI
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html  安装
- https://docs.aws.amazon.com/zh_cn/cli/latest/userguide/cli-configure-files.html
- https://aws.amazon.com/cn/blogs/compute/authenticating-amazon-ecr-repositories-for-docker-cli-with-credential-helper/
### 安装
1. 安装方式一
```bash
apt install awscli
```
2. 安装方式二
linux
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

mac
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```
### 使用
1. 在配置文件内配置访问凭证
~/.aws/config
```conf
[default]
output = json
region = us-east-1
```
~/.aws/credentials
```conf
[default]
aws_access_key_id = XXX
aws_secret_access_key =  XXX
```
2. 在命令行配置访问凭证
```bash
aws configure
```
3. 列出所有凭证
```bash
aws configure list
```

4. 使用指定名字的凭证
  - --profile
  ```bash
  aws s3 ls --profile default
  ```
### CLI操作ECR
1. 创建ECR
```bash
aws ecr create-repository  \
    --repository-name ECR名称   \
    --image-scanning-configuration scanOnPush=true  \
    --region us-east-1
```

2. 推镜像到ECR
```bash
login=`aws ecr get-login --no-include-email --region us-east-1`
$login

# 遇到的错误与解决措施  https://blog.csdn.net/cckavin/article/details/103591380
Error saving credentials: error storing credentials - err: exit status 1, out: `Failed to execute child process “dbus-launch” (No such file or directory)`
apt-get install gnupg2 pass

aws ecr list-images  --repository-name 仓库名
```
4. 其它
```bash
# 执行ec2指令
# 查看实例状态
ec2-describe-instances --region us-east-1 --filter 'tag:aws:cloudformation:stack-name=XXX' --filter 'instance-state-name=running'

# 停止实例
ec2-stop-instances

# 删除实例
aws cloudformation delete-stack --stack-name  gary --region us-east-1

# 创建实例
aws cloudformation create-stack --stack-name gary --region us-east-1  --template-body  stack.json --parameters   ParameterValue=,ParameterKey=Deployer ParameterValue=gary,ParameterKey=StackShortName --capabilities CAPABILITY_IAM

# 查看在CREATE_IN_PROGRESS,ROLLBACK_IN_PROGRESS,DELETE_IN_PROGRESS,UPDATE_IN_PROGRESS状态的stack
cfn-list-stacks --region us-east-1 --stack-status CREATE_IN_PROGRESS,ROLLBACK_IN_PROGRESS,DELETE_IN_PROGRESS,UPDATE_IN_PROGRESS
```
## Amazon VPC间的通信
1. Create Peering Connection
vpc请求方，vpc接收方
2. Route Tables -- Add Route
vpc请求方， vpc接收方，vpc接收方ip地址

## Amazon ES 
1. 仅提供接口给客户，客户通过接口对数据进行存储与查询。
2. Open Distro for Elasticsearch：AWS Elasticsearch 发行版。
3. Open Distro for Elasticsearch: 是 AWS 2019年宣布开源的 Elasticsearch 发行版。Open Distro for Elasticsearch 是完全社区驱动、100%开源、企业级的增强版 Elasticsearch，包含安全、告警、SQL、深度性能分析等在内的诸多核心功能，也包含了Kibana。

## Amazon ElastiCache for Redis
- https://docs.aws.amazon.com/zh_cn/AmazonElastiCache/latest/red-ug/WhatIs.Managing.html
1. 操作ElastiCache for Redis的方式：AWS 管理控制台, AWS CLI,  AWS SDK, ElastiCache API

## Amazon ECS
1. 创建集群
  1. 仅限联网，AWS 提供 Fargate支持。
  2. EC2 Linux + 联网，需要创建EC2
2. 定义任务
  - 可以基于 EC2 或者 FARGATE 运行 
## Amazon EKS
1. eks集群
  Amazon EKS 使用 Amazon VPC 网络策略来将控制层面组件之间的流量限制到一个集群内。除非通过 Kubernetes RBAC 策略授权，否则，集群的控制层面组件无法查看或接收来自其他集群或其他 AWS 账户的通信。
2. AWS资源
  arn:aws:eks:<区域>:<随机数字串>:cluster/<集群名字>
3. eksctl
  命令行工具,用于处理EKS群集,可自动执行许多单独的任务。
4. eks版本和k8s版本一致
 https://docs.aws.amazon.com/zh_cn/eks/latest/userguide/kubernetes-versions.html

## k8s-on-aws
参考文档 https://kubernetes-on-aws.readthedocs.io/en/latest/user-guide/tls-termination.html

## Amazon CloudFront 
- 如果在regional edge cache location找不到指定内容，CloudFront则去请求 源 获取内容并且将内容缓存在regional edge cache location。
1. 源类型，可以同时配置多个源
  1. Amazon S3 存储桶
  2. Amazon ELB
  3. MediaPackage 源
  4. MediaStore 容器
2. 行为
  1. 定义用户请求到CloudFront后，CloudFront将流量打到哪个源上
  2. 第一个源被设置为默认的行为
  
## IAM
- 限制IP来源 https://aws.amazon.com/cn/premiumsupport/knowledge-center/iam-restrict-calls-ip-addresses/

## RDS
```sql
-- 查看binlog配置
call mysql.rds_show_configuration;
call mysql.rds_set_configuration('binlog retention hours', 24);
```