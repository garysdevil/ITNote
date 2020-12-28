## k8s.io/apimachinery/pkg/api/resource
1. 文档 
https://godoc.org/k8s.io/apimachinery/pkg/api/resource#pkg-index

2. type Quantity
https://physics.nist.gov/cuu/Units/binary.html


## 代码生成器
- 参考  
    1. https://zhuanlan.zhihu.com/p/99148110 
    2. https://tangxusc.github.io/2019/05/code-generator%E4%BD%BF%E7%94%A8/
    3. https://www.openshift.com/blog/kubernetes-deep-dive-code-generation-customresources
1. conversion-gen   
    - https://github.com/kubernetes/code-generator
    - 用于自动生成在内部和外部类型之间转换的函数的工具。
2. deepcopy-gen
    - https://godoc.org/k8s.io/gengo/examples/deepcopy-gen

3. defaulter-gen

## client-go
- client-go有四类客户端 
    RestClient、ClientSet、DynamicClient、DiscoveryClient。
    RestClient是最基础的客户端，它对Http进行了封装，支持JSON和protobuf格式数据。
    其它三类客户端都是通过在REStClient基础上再次封装而得来。