---
created_date: 2024-11-19
---

[TOC]

- GPU

## 相关资料
- CUDA（Compute Unified Device Architecture）
    - 由NVIDIA推出的通用并行计算架构。提供了一套应用软件接口（API）。其主要应用于英伟达GPU显卡的调用。
    - https://forums.developer.nvidia.com/

- ROCM
    - 由AMD推出的通用并行计算架构。提供了一套应用软件接口（API）。其主要应用于AMD GPU显卡的调用。

- PCI Peripheral Component Interconnect(外设部件互连标准)
  
- 文章
    - nvcc https://blog.csdn.net/hxxjxw/article/details/119838078
    - cuda https://zhuanlan.zhihu.com/p/522927238

## 显卡
- 显卡参数
    1. 显卡类型/显卡架构
    2. 显卡芯片/核芯频率
    3. 显存
          1. 显存频率： GDDR5比DDR3的显存同核心、同核心频率大约强5%-10%。
          2. 显存位宽。
          3. 显存容量。
          4. 显存带宽。指显示芯片与显存之间的数据传输速率，单位是字节/秒。
    4. 流处理器数量

- 显卡性能
    1. 看显卡性能，先看核心的架构。这些555M，550M，635M，640M LE都是费米架构的，同架构之间性能容易比较。
    2. 看显存类型，GDDR5比DDR3的显存同核心、同核心频率大约强5%-10%。
    3. 同架构显卡，性能先看SP数量或流处理器数量，这是最影响显卡性能的因素，这个数量和性能成正比，比如华硕的555M比联想的555M强在于华硕555M是144SP，联想的是96SP，超了一半的SP数量就是华硕的555M比联想555M强得多的原因。
    4. 看频率和流处理器的乘数估算性能。同架构的显卡大至性能可以用流处理器数量*频率来计算和横向对比。675M频率144SP的555M和750M频率，96SP的555M之间的区别就是675*144和750*96的差值，约30%左右，和跑分的差距相似。

## 异构计算的编程模型
- CUDA 更简单。
- OpenCL 一个开放的标准，跨平台，更灵活。
- Vulkan Computing 跨平台。
- HIP 跨平台。

## CUDA
- CUDA是NVIDIA显卡成熟的开发框架。

1. CUDA Context（上下文）
    - context类似于CPU上的进程上下文，管理了由Driver层分配的资源的生命周期。多线程分配调用的GPU资源同属一个context下，通常与CPU的一个进程对应。
2. CUDA Stream是指一堆异步的CUDA操作.

- 工作流程
    1. 在GPU设备上申请内存。
    2. 将主机内存上的数据拷贝到GPU设备。
    3. 提供GPU一个核函数，该核函数是CPU想让GPU执行的程序。（CUDA kernel function）
    4. 让GPU通过SPMD的方式运行这个核函数。
    5. GPU开始执行。
    6. 将GPU设备上的计算结果传回主机内存。
    7. 释放GPU设备上的内存。

### NVCC
- nvcc是CUDA的编译器，位于bin/目录中。

1. NVCC 建立在 NVVM 优化器之上。
2. NVVM 优化器本身构建在 LLVM 编译器基础结构之上。
3. 实质上，NVCC是一个编译器的调用集合，它会去调用很多其他的编译工具，比如gcc、cicc、ptxas、fatbinary等等。

### SASS
- SASS是CUDA中对应GPU的机器码的硬件指令集。
- SASS指令集与SM架构有直接对应关系，一旦硬件架构设计完成就不再改变。

### PTX ISA
- 术语
    - PTX： Parallel Thread Execution
    - ISA： Instruction Set Architecture（指令集）

- PTX带来兼容性
    - PTX与硬件架构只有比较弱的耦合关系，它本质上是从SASS上抽象出来的一种更上层的软件编程模型，介于CUDA C/C++和SASS之间。
    - PTX可以被当前机器Driver中的jit编译器编译成与当前GPU对应的SASS代码。这样就实现了代码的可移植性和向后兼容。

- PTX
    1. 是一个稳定的编程模型和指令集，是Virtual Architecture的汇编产物。
    2. 这个ISA能够跨越多种GPU，并且能够优化代码的编译等等。
    3. Real Architecture提供的是真实GPU上的指令集，也是最终CUDA程序运行的指令集SASS


## Compute Shader
- Compute Shader是一种技术，是微软DirectX 11 API新加入的特性，在Compute Shader的帮助下，程序员可直接将GPU作为并行处理器加以利用。


## GPU运行环境
### 显卡信息
```bash
# lspci指令

lspci | grep -i vga -A 12 # 查看显卡信息

lspci -vnn | grep VGA -A 12 # 查看显卡信息

lspci -v -s ${62:00.0} # 查看指定显卡的详细信息

lspci -vnn | grep VGA -A 12 | grep 'Family' # 查看显卡信息
# Subsystem: Gigabyte Technology Co., Ltd ASPEED Graphics Family [1458:1000] 
# 1458 代表厂商 ID
# 1000 代表 PCI

lspci | grep -i nvidia # 查看nvidia GPU信息
```

```bash
# lshw指令  就是读取 /proc 里面的一些文件来显示相关的信息

lshw -C display
lshw -C display -short

lshw -c video | grep configuration # 查看所有的显卡驱动名称
modinfo ${driver} # 通过显卡驱动名称查看显卡驱动的详情
```

### cuda编译器
- NVIDIA CUDA toolkit 和  NVIDIA CUDA驱动
    - https://developer.nvidia.com/cuda-downloads
    - https://developer.nvidia.com/cuda-toolkit-archive
    - https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#environment-setup # 安装完设置环境变量 ``export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}``
    - CUDA Toolkit 11.7.0   11.7.0_515.43.04
    - CUDA Toolkit 11.7.1   11.7.1_515.65.01
    - CUDA Toolkit 11.8.0   11.8.0_520.61.05
```bash
# CUDA的编译器
apt update
apt install nvidia-cuda-toolkit
nvcc --version # 查看cuda编译器版本
```

```bash
# 安装NVIDIA CUDA驱动
# add-apt-repository ppa:graphics-drivers/ppa --yes
# apt update
# apt install nvidia-driver-510
# apt install nvidia-driver-* # 选择一个驱动器
# 卸载 CUDA Toolkit
/usr/local/cuda-11.8/bin/cuda-uninstaller
# 卸载 NVIDIA Driver
/usr/local/cuda-11.8/bin/nvidia-uninstall

nvidia-smi -L # 查看NVIDIA显卡型号
nvidia-smi -l 1 # # 查看NVIDIA GPU使用率，每秒刷新一次

nvidia-smi dmon # 设备状态持续显示输出
nvidia-smi pmon # 进程状态持续显示输出

ls /usr/src | grep nvidia  # 查看服务器安装的驱动版本信息
cat /proc/driver/nvidia/version  # 查看运行中的驱动版本信息

# 执行nvidia-smi指令时报错 NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running. 解决办法
apt-get install dkms
dkms install -m nvidia -v $(ls /usr/src | grep nvidia | awk -v FS='-' '{print $2}')
# 如果还是报错，则重启

```

### 报错解决
- Failed to initialize NVML: Driver/library version mismatch
```bash
# 1.卸载驱动
apt-get purge nvidia*
# 2.查找可用的驱动版本
ubuntu-drivers devices
# 3. 查看本机内核版本
cat /proc/driver/nvidia/version
# 4.安装驱动
apt install nvidia-driver-*
```

## 编程
- CUDA编程
    - 在GPU上执行的函数通常称为核函数。
    - 以线程格（Grid）的形式组织，每个线程格由若干个线程块（block）组成，而每个线程块又由若干个线程（thread）组成。
    - 以block为单位执行的。

```c
#include "cuda_runtime.h"

__global__ void func(int c, int* a)
{
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    a[idx] *= c;
}

int main()
{
    return 0;
}
```
```bash
# -gencode= 用来控制具体要生成哪些PTX和SASS代码；多个 -gencode=* 可以支持多个虚拟架构列表。
# arch=compute_30 表示基于compute_30的virtual GPU architecture
# code=\"sm_30,compute_30\"，表示代码生成列表。其中 sm_30 表示基于sm_30的架构生成相应SASS代码，compute_30表示基于compute_30的虚拟架构生成相应PTX代码。
# arch 的配置一定要低于 code ，否者是无法进行编译。

nvcc cudatest.cu -o cudatest -gencode=arch=compute_30,code=\"sm_30,compute_30\" -gencode=arch=compute_52,code=\"sm_52,compute_52\" -gencode=arch=compute_75,code=\"sm_75,compute_75\"
cuobjdump -ptx cudatest # 导出PTX代码
cuobjdump -sass cudatest # 导出SASS代码
```