
## ec2实例
```bash
# 1. 查看正在运行的ec2
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, PrivateIpAddress, InstanceId, InstanceType]' --output text|grep '关键字'

# 1. 根据tag查机器
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,Tags[?Key==`Name`].Value]' --output text|grep ${tag} -B 2

# 2. 添加tag
aws ec2 create-tags --resources ${ID} --tags Key=My1stTag,Value=Value1 Key=My2ndTag,Value=Value2 Key=My3rdTag,Value=Value3

# 3. 重启ec2
aws ec2 reboot-instances --instance-ids  ${ID} 

# 4. 查看ec2
aws ec2 describe-instances --instance-ids  ${ID} 

# 5. 启动ec2
aws ec2 start-instances --instance-ids  ${ID} 

# 6. 关闭ec2
aws ec2  stop-instances --instance-ids  ${ID} 

# 7. 删除ec2
aws ec2  terminate-instances  --instance-ids  ${ID} 

# 9. 列出spot实例
aws ec2 describe-spot-instance-requests --query SpotInstanceRequests[*].{ID:InstanceId}

# 10. 把iam角色附加到ec2
aws ec2 associate-iam-instance-profile --instance-id ${instance-id} --iam-instance-profile Name=${Name}

# 11. 根据内网或者外网ip查机器
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicIpAddress,PrivateIpAddress,InstanceId,Tags[?Key==`Name`].Value]' --output text|grep "${IP}" -A 1

# 12. 升级机器
aws ec2 modify-instance-attribute   --instance-id ${instance-id} --instance-type "{\"Value\": \"c5.xlarge\"}"
```

## vpc网络
```bash
# 1. 创建vpc
aws ec2 create-vpc --cidr-block 172.10.0.0/16

# 2. 查看vpc
aws ec2 describe-vpcs

# 3. 查看可用区
aws ec2 describe-availability-zones

# 4. 创建子网
aws ec2 create-subnet --vpc-id vpc-1c34e475 --cidr-block 172.10.1.0/24 --availability-zone ap-south-1a

# 5. 创建网关
aws ec2 create-internet-gateway

# 6. 把网关绑定到vpc上
aws ec2 attach-internet-gateway --internet-gateway-id igw-4a35f123 --vpc-id vpc-1c34e475

# 7. 查看路由表
aws ec2 describe-route-tables

# 8. 将创建的子网关联路由表
aws ec2 associate-route-table --route-table-id rtb-3cd00c55 --subnet-id subnet-c4815dad

# 9. 在路由表中创建路由
aws ec2 create-route --route-table-id rtb-3cd00c55 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-4a35f123

# 10. 创建密钥对
aws ec2 create-key-pair --key-name aws-mb-personal.pem

# 11. 设置安全组
aws ec2 create-security-group --group-name allow-ssh_web --description "test"  --vpc-id vpc-1c34e475

# 12. 安全组中创建访问规则
aws ec2 authorize-security-group-ingress --group-id sg-5aa21533 --protocol tcp --port 22 --cidr 0.0.0.0/

# 13. 查看安全组访问规则
aws ec2 describe-security-groups  --group-ids sg-5aa21533
```

## 存储卷
```bash
# 1. 创建存储卷
aws ec2 create-volume --size 50 --availability-zone ap-south-1b --volume-type gp2

# 2. 对于卷打tag
aws ec2 create-tags --resources vol-02aaed26650c96fe5 --tags Key=Name,Value=attach-to-instance01-mb

# 3. 把卷附加到指定实例上
aws ec2 attach-volume --volume-id vol-02aaed26650c96fe5 --instance-id ${instance-id} --device /dev/sdf

# 4. 查看卷信息
aws ec2 describe-volumes --volume-id vol-02aaed26650c96fe5

# 5. 实例上分离存储卷
aws ec2 detach-volume --volume-id vol-02aaed26650c96fe5

# 6. 删除存储卷
aws ec2 delete-volume --volume-id vol-02aaed26650c96fe5
```

7.  ec2机器磁盘扩容
```bash

aws ec2 describe-volumes --region us-east-1 --filters Name=attachment.instance-id,Values=${instance-id}


aws ec2 modify-volume --volume-id  vol-0e2b27aecc37135cc   --size 200

sudo growpart /dev/xvda 1

sudo resize2fs /dev/nvme0n1p1


lsblk # 查看设备名称
```

8. eks nodes扩容
```bash
growpart /dev/nvme0n1p1 1 # (如果输出的是中文，那么加一个export LANG=en_us.utf-8，再执行一次)
xfs_growfs /dev/nvme0n1p1  # (是xfs filesystem)


export LANG=en_US.UTF-8
sudo growpart /dev/nvme0n1 1
sudo xfs_growfs -d /
```

## s3
1. 查看
```bash
aws s3 ls
aws s3 ls s3://bucket
aws s3 ls s3://bucket/prefix
# 批量下载
aws s3 cp s3://${path} ./${folder} --recursive --profile ${profile}
```

2. 拷贝
```bash
aws s3 cp /to/local/path s3://bucket/prefix
aws s3 cp s3://bucket/prefix /to/local/path
aws s3 cp s3://bucket1/prefix1 s3://bucket2/prefix2
```

3. 同步
```bash
aws sync [--delete] /to/local/dir s3://bucket/prefixdir
aws sync [--delete] s3://bucket/prefixdir /to/local/dir
aws sync [--delete] s3://bucket1/prefixdir1 s3://bucket2/prefixdir2
```
4. 创建桶
```bash
aws s3api create-bucket --bucket ${my-bucket} --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
```

## elb
```bash
# 1. 查看某个elb
aws elb describe-load-balancers --load-balancer-name project-api-pre

# 2. 查看elbv2以及alb
aws elbv2 describe-load-balancers --name project-vomkttest

# 3. 将某个ec2注册到elb中
aws elb register-instances-with-load-balancer --load-balancer-name my-loadbalancer --instances ${instance-id}

# 4. 将某个ec2从elb中注销
aws elb deregister-instances-from-load-balancer --load-balancer-name project-api-pre --instances ${instance-id}

# 5. 查看elb健康状态
aws elb describe-instance-health --load-balancer-name my-load-balancer

# 6. 关联安全组
aws elb apply-security-groups-to-load-balancer --load-balancer-name my-loadbalancer --security-groups sg-53fae93f

# 7. 添加可用区
aws elb enable-availability-zones-for-load-balancer --load-balancer-name my-loadbalancer --availability-zones us-west-2b

# 8. 删除可用区
aws elb disable-availability-zones-for-load-balancer --load-balancer-name my-loadbalancer --availability-zones us-west-2a

# 9. 添加子网
aws elb attach-load-balancer-to-subnets --load-balancer-name my-load-balancer --subnets subnet-dea770a9 subnet-fb14f6a2

# 10. 删除子网
aws elb detach-load-balancer-from-subnets --load-balancer-name my-loadbalancer --subnets subnet-450f5127

# 11. 配置侦听器
aws elb create-load-balancer --load-balancer-name my-load-balancer --listeners "Protocol=http,LoadBalancerPort=80,InstanceProtocol=http,InstancePort=80" "Protocol=https,LoadBalancerPort=443,InstanceProtocol=http,InstancePort=80,SSLCertificateId="ARN" --availability-zones us-west-2a
```

## 注意事项

设置 EC2 实例:
使用 Amazon EC2 控制台，将您的 EC2 实例与支持访问您的挂载目标的 VPC 安全组关联。例如，如果您向您的挂载目标分配了“默认”安全组，则应将“默认”安全组分配到您的 EC2 实例。了解更多
打开 SSH 客户端并连接到您的 EC2 实例。(了解如何连接。)
如果您使用的是 Amazon Linux EC2 实例，请使用以下命令安装 EFS 挂载帮助程序:
sudo yum install -y amazon-efs-utils
如果您未使用 Amazon Linux 实例，也仍可使用 EFS 挂载帮助程序。了解更多

如果您未使用 EFS 挂载帮助程序，请在您的 EC2 实例上安装 NFS 客户端:
在 Red Hat Enterprise Linux 或 SUSE Linux 实例上，使用此命令:
sudo yum install -y nfs-utils
在 Ubuntu 实例上，使用此命令:
sudo apt-get install nfs-common
挂载您的文件系统
打开 SSH 客户端并连接到您的 EC2 实例。(了解如何连接。)
在 EC2 实例上创建新目录，如“efs”。sudo mkdir efs
使用下面的列出的方法挂载您的文件系统。如果您需要对传输中的数据加密，请使用 EFS 挂载帮助程序和 TLS 挂载选项。挂载注意事项 使用 EFS 挂载帮助程序:
sudo mount -t efs fs-d6fab935:/ efs
使用 EFS 挂载帮助程序和 TLS 挂载选项:
sudo mount -t efs -o tls fs-d6fab935:/ efs
使用 NFS 客户端:
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-d6fab935.efs.us-east-1.amazonaws.com:/ efs


## 安全组规则
```bash
# 1. 安全组中添加规则

aws ec2 authorize-security-group-ingress --group-name  ${group_name} --protocol tcp --port 443 --cidr ${IP}/32

aws ec2 authorize-security-group-ingress --group-id ${group_id} --protocol tcp  --port  49102  --cidr  ${IP}/32

aws ec2 authorize-security-group-ingress --group-id  ${group_id} --protocol tcp  --port  38022   --source-group ${source_group_id}

# 2. 更新安全组规则
aws ec2 update-security-group-rule-descriptions-ingress --group-id ${group_id}  --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "IpRanges": [{"CidrIp": "${IP}/16", "Description": "SSH access from ABC office"}]}]'


# 3. 删除安全组中的规则
aws ec2 revoke-security-group-ingress --group-name ${group-name} --protocol tcp --port 80 --cidr ${IP}/32

aws ec2 revoke-security-group-ingress --group-id  ${group_id} --protocol tcp   --port 49102 --cidr ${IP}/32
```
## 添加路由表
```bash
aws ec2 create-route --route-table-id ${route_table_id}  --destination-cidr-block ${IP}/32 --network-interface-id   eni-0ecf1228a078c99e7

aws ec2 delete-route --route-table-id rtb-044654990eeb5d685 --destination-cidr-block  ${IP}/32

```
## ses
aws ses get-account-sending-enabled --region us-east-1 

aws ses update-account-sending-enabled --enabled --region us-east-1 

## 创建ecr
```bash
aws ecr create-repository  \
    --repository-name ${project}  \
    --image-scanning-configuration scanOnPush=true  \
    --region us-east-1
```

## 创建eks集群
```bash
eksctl create cluster --name project-pay --version 1.14 --region us-east-1 --vpc-private-subnets=subnet-0bb1762f69c14375d,subnet-0fa86dfc8e7e49e22 --authenticator-role-arn=${authenticator_role_arn}
```

## 其它
1. 将aws映像传到s3然后下载下来
```bash
# 将aws映像传到s3
image-id=ami-1111111111
bucket=test
aws ec2 export-image --image-id ${image_id} --disk-image-format VMDK --s3-export-location S3Bucket=${bucket},S3Prefix=/
# 查看 aws映像传到s3 的状态
task_id=export-ami-07633824272301234 # 上面的指令执行后会输出进程ID
aws ec2 describe-export-image-tasks --export-image-task-ids ${task_id}  # 查看导出进程状态，直到completed就说明完成了
# 从s3下载文件
filename=export-ami-08a410d2a40091234.vmdk
aws s3 cp s3://${bucket}//${filename} ./
```