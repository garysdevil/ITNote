---
created_date: 2021-11-30
---

[TOC]

## html解析为可视化界面

- 从顶部往下解析

1. 解析HTML，生成DOM树；解析CSS，生成CSSOM树
2. 将 DOM 树和 CSSOM 树结合，生成渲染树(Render Tree)
3. Layout(回流): 根据生成的渲染树，进行回流(Layout)，得到节点的几何信息（位置，大小）
4. Painting(重绘): 根据渲染树以及回流得到的几何信息，得到节点的绝对像素
5. Display: 将像素发送给GPU，展示在页面上。（这一步其实还有很多内容，比如会在GPU将多个合成层合并为同一个层，并展示在页面中。而css3硬件加速的原理则是新建合成层）

## 前端

### Javascript

```html
<!-- 引入javascritp的第一种方式，直接引用javascript文件-->
<script type="text/javascript" src="../js/jquery-1.8.3.js"></script>
<script src="https://unpkg.com/@metamask/detect-provider/dist/detect-provider.min.js"></script>

<script type="module">
    import "https://unpkg.com/@metamask/detect-provider/dist/detect-provider.min.js";
    (async _ =>{ 
        alert("test")
    })()
</script>

<!-- 引入javascritp的第二种方式 -->
<script type="text/javascript">
    alert("aaa")
</script>
```

### Jquery

```js
$(selector).each(function(index,element))
```

### 事件驱动

1. web交互,通过事件监听

   1. 将函数写在html的元素里。
   2. onclick。
   3. addEventListener(0

2. 事件委托：解决事件监听过多会消耗内存和减慢加载速度速度的问题。
