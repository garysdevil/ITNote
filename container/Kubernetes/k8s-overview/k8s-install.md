## 二进制安装
https://github.com/easzlab/kubeasz
https://my.oschina.net/u/4255236/blog/4873696

## kind 测试环境
- 参考
https://kind.sigs.k8s.io/  

```bash
# 简单创建集群
kind create cluster --name kind-1

# 根据配置文件创建集群
kind create cluster --config kind-config.yaml

# 查看所有集群
kind get clusters

# 获取集群的配置
kind get kubeconfig > /tmp/admin.conf

# 使用kubectl操作集群
kubectl config set-context kind-kind 或者
export KUBECONFIG=集群的配置文件位置

# 查看k8s集群信息
kubectl cluster-info --context ${contexts.context.name}

# 查看 kubectl 已知的位置和凭证
kubectl config view

# 加载一个镜像进node里
kind load docker-image ${image-name}

# 查看node里的镜像
docker exec ${node-name} crictl images
```

vim kind-config.yaml
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
# kind create cluster --config kind.yaml
```

