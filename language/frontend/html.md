## html解决为可视化界面
- 从顶部往下解析
1. 解析HTML，生成DOM树；解析CSS，生成CSSOM树
2. 将 DOM 树和 CSSOM 树结合，生成渲染树(Render Tree)
3. Layout(回流): 根据生成的渲染树，进行回流(Layout)，得到节点的几何信息（位置，大小）
4. Painting(重绘): 根据渲染树以及回流得到的几何信息，得到节点的绝对像素
5. Display: 将像素发送给GPU，展示在页面上。（这一步其实还有很多内容，比如会在GPU将多个合成层合并为同一个层，并展示在页面中。而css3硬件加速的原理则是新建合成层）

## GoogleBrower DevTool
- 文档 
https://developers.google.com/web/tools/chrome-devtools/
https://www.cnblogs.com/vvjiang/p/12370112.html
### Network
浏览器根据html中外连资源出现的顺序，依次放入队列（Queue）,然后根据优先级确定向服务器获取资源的顺序。同优先级的资源根据html中出现的先后顺序来向服务器获取资源
1. Time 总共花费的时间
#### waterfall
https://developers.google.com/web/tools/chrome-devtools/network/reference#timing-explanation
- 关键指标
1. Queued at 页面加载过程中，加入到请求队列的起始时间

2. Started  at 请求加入到队列之后，开始处理的起始时间

3. Queueing 请求排队的时间。
    1. 有更高优先级的请求。
    2. 浏览器与同一个域名建立的TCP连接数是有限制的，chrome设置的6个。已为该来源打开了六个TCP连接。仅适用于HTTP/1.0和HTTP/1.1。
    3. 浏览器正在磁盘缓存中短暂分配空间

4. Initial Connection 建立TCP连接的时间，包括TCP的三次握手和SSL的认证。

5. SSL完成ssl认证的时间。

6. Request sent 请求第一个字节发出前到最后一个字节发出后的时间，也就是上传时间

7. Waiting (TTFB) 是浏览器请求发送到服务器的时间+服务器处理请求时间+响应报文的第一字节到达浏览器的时间。 这个指标可以来判断web服务器是否性能不够, 或者说是否需要使用CDN。

8. Content Download 是浏览器用来下载资源所用的时间。这个指标越长, 说明资源越大. 理想情况下, 可以通过控制资源的大小来控制这段时间的长度。
