---
created_date: 2020-11-16
---

[TOC]

生产者，消费者，频道，交换机，队列，路由键。
producer，consumer，channel，exchange，queue，routing key。
note：路由键可以简单地理解为queue的名字。

交换器类型Exchange Type
direct：接收者和队列进行绑定。生产者和接收者的路由键需要完全一致匹配。
channel.sendToQueue(queue, Buffer.from(msg), { persistent: true });

channel.prefetch(1);\
don't dispatch a new message to a worker until it has processed and acknowledged the previous one.
Instead, it will dispatch it to the next worker that is not still busy.

fanout: 用于订阅模式，接收者直接和交换机进行绑定，不需要路由键。假如没有接收者，消息直接被丢弃。
channel.publish(exchange, key, Buffer.from(msg));

topic: 用于订阅模式，接收者直接和交换机进行绑定，需要路由键。接收者的路由键和发送者的路由键进行规则匹配（\*，#）。
channel.publish(exchange, key, Buffer.from(msg));

header: 未学。

RPC: 接收者需要绑定队列。
channel.sendToQueue('rpc_queue',Buffer.from(num.toString()), {correlationId,replyTo: q.queue,});

关于queue
exclusive: true 随机产生一个queue，当client连接断开时，销毁。
persistent: true queue的消息持久化。

rabbitmqctl list_queues
rabbitmqctl list_exchanges
rabbitmqctl list_queues name messages_ready messages_unacknowledged
rabbitmqctl list_bindings
