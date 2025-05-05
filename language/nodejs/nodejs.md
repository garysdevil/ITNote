---
created_date: 2021-08-23
---

[TOC]

# nodejs

- 单线程异步IO机制

- 为什么说nodejs是单线程的？

  - 因为nodejs只有主线程在执行代码，所有的网络请求（Socket）由主线程来执行代码，然后返回数据。涉及到代码外的操作（例如 请求第三方接口、数据库读取、文件读取），则非阻塞式交给线程池进行处理。

## 优缺点

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

## 闭包

- 定义：一个函数作用域内 读取了 另一个函数作用域内 的变量。
- 发生：只有在嵌套函数内才会出现闭包现象。

1. 使用场景
   1. 设计私有的方法和变量。
2. 缺点
   1. 变量不被释放，会产生内存泄露问题。

## Node应用管理器 pm2

pm2 list

## CJS vs EMS

### 模块的加载

- CommonJS Modules CJS模块系统，将每个文件都被视为一个单独的模块。

- ECMAScript Modules ESM模块系统，是打包 JavaScript 代码以供重用的官方标准格式。使用 import 和 export 导入导出模块。

- 配置

  - Node.js 默认将 JavaScript 代码视为 CommonJS 模块。
  - 可以通过.mjs 文件扩展名 或者 package.json 'type’字段，来默认将 JavaScript 代码视为 CommonJS 模块。
    ```json  package.json
    {
        "type": "module",
            "dependencies": {
            "babel-core": "^6.26.3",
            "babel-preset-env": "^1.7.0",
            }
    }
    ```

```js
// es3:
var ethers = require(‘ethers’);

// CJS模块化标准
module.export = 变量名; // 导出方式一
export { 变量名1, 变量名2 }; // 导出方式二
const ethers = require(‘ethers’);

// EMS/ES6模块化
export default = { 变量名1, 变量名 } // 导出方式一
export { 变量名1, 变量名2 }; // 导出方式二
import { 变量名 } from ‘ethers’;
import { 变量名 } from ‘./ethers.js’;
import * as 变量名 from ‘ethers’;
```

### 其它

- ESM 默认使用了严格模式，因此在 ES 模块中的`this`不再指向全局对象（而是 `undefined`），且变量在声明前无法使用。

- ESM 缺乏 \_\_filename 和 \_\_dirname

## ts

- nodejs环境下执行ts代码 https://github.com/TypeStrong/ts-node
