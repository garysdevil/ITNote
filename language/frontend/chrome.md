---
created_date: 2022-06-07
---

[TOC]

# Chrome

- chrome内部所有链接 chrome://chrome-urls/

- 调试 chrome://net-internals/

  - 清除游览器dns
  - ...

- webrtc调试 chrome://webrtc-internals/

- Chrome 自定义用户数据目录

  - 在指令后面添加 --user-data-dir=用户数据目录路径
  - 例如 `"C:\Program Files\Google\Chrome\Application\chrome.exe" --user-data-dir=D:\APP\Chrome\1`

## Chrome 快捷键

1. cmd + w 关闭当前标签页
2. cmd + shift + w 关闭当前浏览器

# Chrome DevTool

- 参考
  - https://developers.google.com/web/tools/chrome-devtools/
  - https://www.cnblogs.com/vvjiang/p/12370112.html
  - https://www.jianshu.com/p/24b93b13e5a9

## Network

- 浏览器根据html中外连资源出现的顺序，依次放入队列（Queue）,然后根据优先级确定向服务器获取资源的顺序。同优先级的资源根据html中出现的先后顺序来向服务器获取资源
  1. Time： 总共花费的时间
  2. DOMContentLoaded： dom内容加载并解析完成的时间,此时间段页面白屏
  3. Load：页面加载完成时间

### waterfall

- https://developers.google.com/web/tools/chrome-devtools/network/reference#timing-explanation
- 关键指标

1. Queued at 页面加载过程中，加入到请求队列的起始时间

2. Started at 请求加入到队列之后，开始处理的起始时间

3. Queueing 请求排队的时间。

   1. 有更高优先级的请求。
   2. 浏览器与同一个域名建立的TCP连接数是有限制的，chrome设置的6个。已为该来源打开了六个TCP连接。仅适用于HTTP/1.0和HTTP/1.1。
   3. 浏览器正在磁盘缓存中短暂分配空间

4. Initial Connection 建立TCP连接的时间，包括TCP的三次握手和SSL的认证。

5. SSL完成ssl认证的时间。

6. Request sent 请求第一个字节发出前到最后一个字节发出后的时间，也就是上传时间

7. Waiting (TTFB) 是浏览器请求发送到服务器的时间+服务器处理请求时间+响应报文的第一字节到达浏览器的时间。 这个指标可以来判断web服务器是否性能不够, 或者说是否需要使用CDN。

8. Content Download 是浏览器用来下载资源所用的时间。这个指标越长, 说明资源越大. 理想情况下, 可以通过控制资源的大小来控制这段时间的长度。

## Recorder

1. Chrome 97 于 2022年1月4日 正式发布。
2. Chrome 97 引入了 Recorder 面板（用于录制用户操作流程）。

## Console

```js
let element = 'div._affix_oe51y_42'
document.querySelectorAll(element)
// 返回 NodeList[]：类名不存在。
// 返回 NodeList[div, ...]：类名存在。
```

```js
let xpath1 = '//div[@class="_left_utrae_24"]]'
let xpath = '//div[@class="_affix_oe51y_42"]//div[starts-with(text(), "0x")]'
// 匹配符合xpath的元素集合
$x(xpath)
// 元素集合长度
$x(xpath).length
// 元素集合的第一个元素
$x(xpath)[0]
// 遍历元素集合，输出内容
$x(xpath).forEach(div => console.log(div.textContent));
```

```js
let xpath1 = '//div[@class="_status_utrae_43"]';
$x(xpath1).forEach(div => {
    // 获取所有后代节点
    let allDescendants = div.querySelectorAll('*');
    allDescendants.forEach(node => {
        // 只输出有文本内容的节点
        if (node.textContent.trim()) {
            console.log(node.textContent.trim());
        }
    });
});

let xpath1 = '//div[@class="_status_utrae_43"]';
$x(xpath1).forEach(div => {
    // 只获取直接子节点
    let children = div.children;
    Array.from(children).forEach(child => {
        if (child.textContent.trim()) {
            console.log(child.textContent.trim());
        }
    });
});
```
