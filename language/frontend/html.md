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
### Network
浏览器根据html中外连资源出现的顺序，依次放入队列（Queue）,然后根据优先级确定向服务器获取资源的顺序。同优先级的资源根据html中出现的先后顺序来向服务器获取资源
#### waterfall
https://developers.google.com/web/tools/chrome-devtools/network/reference#timing-explanation
- 关键指标
1. Waiting (TTFB) 是浏览器请求发送到服务器的时间+服务器处理请求时间+响应报文的第一字节到达浏览器的时间。 这个指标可以来判断web服务器是否性能不够, 或者说是否需要使用CDN。
2. Content Download 是浏览器用来下载资源所用的时间。这个指标越长, 说明资源越大. 理想情况下, 可以通过控制资源的大小来控制这段时间的长度。