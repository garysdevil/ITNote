## update
- 滚动升级，
1. update：改变镜像tag：
  kubectl set image deployment/名字 容器名字=镜像 --record
  kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 --record
  
2. update：通过edit配置文件改变镜像tag：
  kubectl edit deployment/pod 名字

3. 查看pod迭代状况
kubectl rollout status deployment deployment名字
--watch=false 非持续查看

4. 查看特定版本的详细信息：
  kubectl rollout history deployment
  kubectl rollout history deployment 名字 --revision=版本

5. 回滚到上一个版本：
  kubectl rollout undo deployment 名字
  回滚到特定的版本 --to-revision=版本号

6. 回滚到指定版本
kubectl rollout undo deployment 名字 --to-revision=1
