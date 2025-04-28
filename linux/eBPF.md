- 参考
    - http://www.brendangregg.com/blog/2019-01-01/learn-ebpf-tracing.html
    - https://coolshell.cn/articles/22320.html#google_vignette

- eBPF（extened Berkeley Packet Filter）是一种内核技术，它允许开发人员在不修改内核代码的情况下运行特定的功能。eBPF 的概念源自于 Berkeley Packet Filter（BPF），后者是由贝尔实验室开发的一种网络过滤器，可以捕获和过滤网络数据包。
- 出于对更好的 Linux 跟踪工具的需求，eBPF 从 dtrace中汲取灵感，[dtrace](https://illumos.org/books/dtrace/chp-intro.html) 是一种主要用于 Solaris 和 BSD 操作系统的动态跟踪工具。与 dtrace 不同，Linux 无法全面了解正在运行的系统，因为它仅限于系统调用、库调用和函数的特定框架。在Berkeley Packet Filter  (BPF)（一种使用内核 VM 编写打包过滤代码的工具）的基础上，一小群工程师开始扩展 BPF 后端以提供与 dtrace 类似的功能集。 eBPF 诞生了。2014 年随 Linux 3.18 首次限量发布，充分利用 eBPF 至少需要 Linux 4.4 以上版本。


## 使用
1. 检查系统内核是否支持 eBPF 
    1. `ls /sys/fs/bpf 和 lsmod | grep bpf`
    2. 如果不支持需要，内核配置文件中启用 eBPF 相关的选项，并重新编译内核。