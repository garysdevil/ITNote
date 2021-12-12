
### ECMAScript(语法基础)


### 创建第一个Node.js应用
1. 引入required模块：使用require指令来载入Node.js模块。
2. 创建服务.
3. 通过监听接收请求与响应请求。
```js nodejss
var http = require('http');
http.createServer(function (request, response) {
    // 发送 HTTP 头部 
    response.writeHead(200, {'Content-Type': 'text/plain'});
    // 发送响应数据 "Hello World"
    response.end('Hello World\n');
}).listen(8888);
// 终端打印如下信息
console.log('Server running at http://127.0.0.1:8888/');
```

### 优缺点
1. 为什么说node.js是单线程高性能适合IO密集型的程序？
    1. 只有主线程在不断地循环等待使用CPU进行运算，所有的运算操作都要排队，一一要交给主线程。
    2. 每一次IO操作，node.js都可以进行异步操作，交给一个新的线程去执行。
2. 优点：
    - 高性能-避免了线程切换使用CPU所带来的各种开销。
    - 线程安全-变量只会被主线程读写。
    - IO异步。
3. 缺点
    - CPU密集型任务占用CPU时间长
4. 总而言之：IO操作是多线程的，CPU操作是单线程的。

### 闭包
- 定义：一个函数作用域内 读取了 另一个函数作用域内 的变量。 
- 发生：只有在嵌套函数内才会出现闭包现象。
1. 使用场景
    1. 设计私有的方法和变量。
2. 缺点
    1. 变量不被释放，会产生内存显露问题。
    
### 其它
事件驱动
events.EventEmitter()
util.inherits(对象名 , events.EventEmitter);
readFile('路径',回调函数);

.on
.emit

IO操作
fs
流
buffer
管道操作 .pipe()

### pm2
pm2 list