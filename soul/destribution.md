## 分布式算法
### raft
1. 
Raft 工作流程分为Propose，Append，Broadcast 和 Apply。
客户发起交易，叫做 Propose
记录交易，这个叫做 Append
通知其他网点，这个叫做 Broadcast
等最后知道大部分网点都确认了这笔交易记录，就执行交易，也就是 Apply。

2. 
对于客户 A，操作是 Propose，Append，Broadcast， Apply，对于客户 B 也是一样的流程，之前我们必须等 A 完成了，才能处理 B。
3. 
Batch

如果很多客户同时要发起交易，那么我们可以将这些交易记录，用一个消息发送过去到其他网点，这样我们就不需要一个一个的发送消息了，这就是 Batch。

各个网点之间距离还是有点远的，消息传递的时间开销还是有点大的。使用 Batch 可以减少消息的发送次数，自然就能提高效率了。
### CAP 分布式 
P分区容错性。
A数据一致性。
C可用性。
由于不同的操作设置在了不同的节点（服务器）上，存在网络延迟故障等。
P：A服务需要操作node1和node2才能实现，为了防止nodeA和nodeB之间发生网络故障而终止服务，因此使用nodeA1和nodeB2对nodeA和nodeB分别作了同步。
A：nodeA和nodeA1的数据要保持一致。
C：nodeA要一一直是可被使用。