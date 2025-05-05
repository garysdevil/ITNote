---
created_date: 2022-02-04
---

[TOC]

## 相关链接

1. Vue官方文档 https://v3.cn.vuejs.org/

2. Vue源码 https://github.com/vuejs/core

3. Vue在线编辑器 https://codepen.io/team/Vue/pen/KKpRVpx

4. uni-app官网 https://uniapp.dcloud.io/history

5. uni-app编译器 https://www.dcloud.io/hbuilderx.html

## Vue

### 声明式地将数据渲染进 DOM 的系统

```html
<div id="counter">
    Counter: {{ counter }}
</div>
<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const Counter = {
        data() {
            return {
                counter: 0
            }
        },
        mounted() { // 设置Counter变量被绑定时触发的动作
            setInterval(() => {
                this.counter++
            }, 1000)
        }
    }
    Vue.createApp(Counter).mount('#counter')
</script>
```

### 通过以 v- 开头的attribute提供特殊的功能

```html
<div id="bind-attribute">
    <!-- 指令带有前缀 v-，表示它们是 Vue 提供的特殊 attribute  -->
    <!-- v-bind:title="message" 表示和当前的信息保存一致 -->
  <span v-bind:title="message"> 
    鼠标悬停几秒钟查看此处动态绑定的提示信息！
  </span>
</div>
<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const AttributeBinding = {
    data() {
        return {
            message: 'You loaded this page on ' + new Date().toLocaleString()
            }
        }
    }

    Vue.createApp(AttributeBinding).mount('#bind-attribute')
</script>
```

### 通过 v-on 指令，添加一个事件监听器

```html
<div id="event-handling">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">反转 Message</button>
  <!-- <button v-on:click="方法名称">web页面显示的按钮名称</button> -->
</div>

<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const EventHandling = {
    data() {
        return {
            message: 'Hello Vue.js!'
        }
    },
    methods: {
        reverseMessage() {
            this.message = this.message
                .split('')
                .reverse()
                .join('')
            }
        }
    }

    Vue.createApp(EventHandling).mount('#event-handling')
</script>
```

### 通过 v-model 指令，实现表单输入和应用状态之间的双向绑定

```html
<div id="two-way-binding">
  <p>{{ message }}</p>
  <input v-model="message" />
</div>

<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const TwoWayBinding = {
        data() {
            return {
                message: 'Hello Vue!'
            }
        }
    }

    Vue.createApp(TwoWayBinding).mount('#two-way-binding')
</script>
```

### 通过 v-if 指令，实现条件

```html
<div id="conditional-rendering">
  <span v-if="seen">现在你看到我了</span>
</div>

<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const ConditionalRendering = {
        data() {
            return {
                seen: true
            }
        }
    }

    Vue.createApp(ConditionalRendering).mount('#conditional-rendering')
</script>
```

### 通过 v-for 指令，实现循环

```html
<div id="list-rendering">
  <ol>
    <li v-for="item in list">
      {{ item.text }}
    </li>
  </ol>
</div>

<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const ListRendering = {
        data() {
            return {
                list: [
                    { text: 'Learn JavaScript' },
                    { text: 'Learn Vue' },
                    { text: 'Build something awesome' }
                ]
            }
        }
    }

    Vue.createApp(ListRendering).mount('#list-rendering')
</script>
```

### 组件化应用构建一

```html
<ol id='component_test'>
  <!-- 创建一个 todo-item 组件实例，在js代码中对应组建名为TodoItem -->
  <todo-item></todo-item>
</ol>

<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">

    // 创建一个组件
    const TodoItem = {
        template: `<li>This is a todo</li>`
    }

    // 创建 Vue 应用
    const app = Vue.createApp({
        components: {
            TodoItem // 注册一个新组件
        }
    })

    // 挂载 Vue 应用
    app.mount('#component_test')
</script>
```

### 组件化应用构建二

```html
<div id="todo-list-app">
  <ol>
     <!--
      现在我们为每个 todo-item 提供 todo 对象
      todo 对象是变量，即其内容可以是动态的。
      我们也需要为每个组件提供一个“key”
    -->
    <todo-item
      v-for="item in groceryList"
      v-bind:todo="item"
      v-bind:key="item.id"
    ></todo-item>
  </ol>
</div>

<script src="https://unpkg.com/vue@next"></script>

<script type="text/javascript">
    const TodoItem = {
        props: ['todo'], // 子单元通过 prop 接口与父单元进行了良好的解耦，父单元的数据传递进props里
        template: `<li>{{ todo.text }}</li>`
    }

    const TodoList = {
        data() {
            return {
                groceryList: [
                    { id: 0, text: 'Vegetables' },
                    { id: 1, text: 'Cheese' },
                    { id: 2, text: 'Whatever else humans are supposed to eat' }
                ]
            }
        },
        components: {
            TodoItem
        }
    }

    const app = Vue.createApp(TodoList)

    app.mount('#todo-list-app')
</script>
```
