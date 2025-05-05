---
created_date: 2022-04-11
---

[TOC]

## PyTorch
- 定义
    - PyTorch是一个开源的Python机器学习库，基于Torch，用于自然语言处理等应用程序。

- 来源
    - 2017年1月，由Facebook人工智能研究院（FAIR）基于Torch推出了PyTorch。

- 功能
    - 它是一个基于Python的可续计算包，提供两个高级功能：
        1. 具有强大的GPU加速的张量计算（如NumPy）。
        2. 包含自动求导系统的深度神经网络。

- 下载安装 
    - https://pytorch.org/get-started/locally/


```py
import torch
print(torch.__version__)  # 查看版本
print(torch.version.cuda) #  PyTorch 所依赖的 CUDA 版本
print(torch.cuda.is_available())  # 查看 torch 是适用于当前主机的CUDA版本
print(torch.cuda.get_device_name(0))  # 查看 GPU 名称
```

## TensorFlow  
- 定义
    - 一个开源的Python机器学习库。
- 来源
    - 2015年，Google Brain发布。


## MSVC
Microsoft C++ Build Tools
https://visualstudio.microsoft.com/visual-cpp-build-tools/