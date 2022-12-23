# nodejs
- 单线程异步IO机制

- 为什么说nodejs是单线程的？
    - 因为nodejs只有主线程在执行代码，所有的网络请求（Socket）由主线程来执行代码，然后返回数据。涉及到代码外的操作（例如 请求第三方接口、数据库读取、文件读取），则非阻塞式交给线程池进行处理。


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

- ESM 默认使用了严格模式，因此在 ES 模块中的``this``不再指向全局对象（而是 ``undefined``），且变量在声明前无法使用。

- ESM 缺乏 __filename 和 __dirname


## ts
- nodejs环境下执行ts代码 https://github.com/TypeStrong/ts-node