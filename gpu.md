- GPU

## 异构计算的编程模型
- OpenCL 更灵活。
- CUDA 更简单。
### CUDA
- NVIDIA显卡成熟的开发框架。

- 工作流程
    1. 在device (也就是GPU) 上申请内存
    2. 将host (也就是CPU) 上的数据拷贝到device
    3. 执行 CUDA kernel function
    4. 将device上的计算结果传回host
    5. 释放device上的内存

### OpenCL
- 一个开放的标准


## Compute Shader
- Compute Shader是一种技术，是微软DirectX 11 API新加入的特性，在Compute Shader的帮助下，程序员可直接将GPU作为并行处理器加以利用。