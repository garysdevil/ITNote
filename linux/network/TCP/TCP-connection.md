https://blog.csdn.net/hkhl_235/article/details/79721645
tcp连接建立：
LISTEN：侦听来自远方的TCP端口的连接请求
SYN-SENT：在发送连接请求后等待匹配的连接请求（客户端）
SYN-RECEIVED：在收到和发送一个连接请求后等待对方对连接请求的确认（服务器）
ESTABLISHED：代表一个成功建立的连接

连接断开：
FIN-WAIT-1：等待远程TCP连接中断请求，或先前的连接中断请求的确认（客户端）
CLOSE-WAIT：等待上层应用发来的连接中断请求（服务端）
FIN-WAIT-2：从远程TCP等待连接中断请求（客户端）（半关闭状态）
CLOSING：等待远程TCP对连接中断的确认（罕见。往往发生在双方同时close一个SOCKET连接，双方同时收到FIN报文）
LAST-ACK：等待原来的发向远程TCP的连接中断请求的确认（服务端）
TIME-WAIT：d（客户端）
CLOSE：关闭连接
