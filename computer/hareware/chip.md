## 相关链接
- 相关文章
    - GPU,CPU,SOC,DSP,FPGA,ASIC,MCU,MPU，GPP，ECU等都是什么 https://www.sohu.com/a/524003146_560178
    - FPGA, CPU, GPU, ASIC区别，FPGA为何这么牛 http://news.sohu.com/a/524904178_121266081
    - GPU基本知识和CUDA C编程(向量加法) https://zhuanlan.zhihu.com/p/434572353
    - CPU、GPU、NPU等芯片架构、特点研究 http://t.zoukankan.com/liuyufei-p-13259264.html

## 芯片架构
- ASIC
    - Application Specific IntegratedCircuit（专用定制芯片），也被称为专用集成电路。
    - 介绍： 芯片内部架构较为简单，不可以硬件编程，只能用来专门处理某一种功能，灵活性最差，但是在执行某一种任务上的效率最高。
    - 产商： ASIC里面有多种架构，谷歌的TPU、地平线BPU、寒武纪和华为都推出的NPU等。

- FPGA
    - Field Programmable Gate Array（可编辑门阵列），也被称为可编程集成电路。
    - 介绍： 芯片内部架构稍微复杂一些，可以硬件编程，因而可以通过硬件编程语言来改变内部芯片的逻辑结构，从而能够在提供一定灵活性的同时，还能够保证较高的处理效率，算是在灵活性和性能上取了个折中。

- CPU
    - Central Processing Unit（中央处理器），也被称为通用集成电路。
    - 介绍： CPU芯片内部架构最复杂，不可以硬件编程，但是可以通过外部的编程软件来编写实现各种功能的软件，具备最高的灵活性，和最低的处理效率。
    - 产商： Intel英特尔 、 AMD 、 苹果M1。

- GPU
    - Graphics Processing Unit（图形处理器）,也被称为视觉处理单元（VPU）、显示核心、视觉处理器、显示芯片。
    - 介绍：不可以硬件编程，但是可以通过外部的编程软件来编写实现各种功能的软件。相比于CPU，GPU的逻辑运算单元（ALU）小而多，控制器功能简单。擅长高强度的并行计算。
    - 产商： NVIDIA英伟达 、 AMD 、 Intel英特尔。

## GPU
- 显卡有两大厂商
    - Nvidia（英伟达），N卡
    - AMD，A卡

- N卡
    - 命名规则分为前缀、代号和后缀三个部分。
        - 前缀分别有GT、GTS、GTX和RTX，性能指数分别对应：低端、入门、中端、高端。
        - 代号数字第一至第二位代表系列（代数），代数越新越好。
        - 后两位代表性能，后缀常见的有super和ti，分别都是代表是这个型号的加强版。
    - 例如 RTX2080ti，就是高端20系列，性能指数80的加强版显卡。

- A卡
    - 命名规则分为前缀、代号和后缀三个部分
        - 三代之前前缀分为：R9高端、R7中端、R5入门以及R3低端，在往前就是远古时代的HD开头了。