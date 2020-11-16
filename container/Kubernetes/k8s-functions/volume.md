### Volume
- 参考文档
https://kubernetes.io/docs/concepts/storage/volumes/
https://www.kubernetes.org.cn/4069.html

- volume是kubernetes Pod中多个容器访问的共享目录。
- volume被定义在pod上，被这个pod的多个容器挂载到相同或不同的路径下。
- Volume 的生命周期可以独立于容器。

##### 常见的Volume类型
1. emptyDir：把宿主机的空目录挂载进pod, 会在宿主机上创建数据卷目录并挂在到容器中。这种方式，Pod被删除后，数据也会丢失。
2. hostPath：把宿主机的真实存在的目录挂载进Pod。这种方式，Pod被删除后，数据不会丢失。

3. rbd：可读写的方式映射只能映射给一个用户使用，只读的方式可以同时映射给多个用户使用。

3. CephFS：可读写的方式能映射给多个用户使用。

- PersistentVolumeClaim
    
    pod - pvc - pv 是用户对存储资源的请求
    pod - * - node
- subPath
    volumeMounts.subPath
    指定卷中的一个子目录，映射进容器内。