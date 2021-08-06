#### golang的栈内存分配机制
- 当创建一个goroutine时，Go运行时会分配一段8K字节的内存用于栈供goroutine运行使用，
1. 第一代 分段栈(Segmented Stacks)
    - 扩栈：通过morestack函数 
    - 缩栈：通过lessstack缩栈。
    - 缺陷：栈缩时性能开销大
2. 第二代 连续栈（continuous stacks）
    - 扩栈：创建一个两倍于原stack大小的新stack，并将旧栈拷贝到其中。
    - 缩栈：垃圾回收的过程中实现
    - 缺陷：分配了更多的栈空间，但微不足道。