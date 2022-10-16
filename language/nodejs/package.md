## 内置包
```js
// base64加解密
var b = new Buffer.from('JavaScript');
var s = b.toString('base64');

var b = new Buffer.from('编码后的base64字符串', 'base64')
var s = b.toString();

// 将字符串解析问json对象
JSON.parse(json_string))
// 将json对象解析为json字符串
JSON.stringify(json_obj, null, 4)

// 文件操作
// var fs = require("fs")
fs.writeFileSync("./1.html", "data")

```

## 第三方包 package
1. Dataloader
    - 是由facebook推出，能大幅降低数据库的访问频次，经常在Graphql场景中使用。
    - 主要通过2个机制来降低数据库的访问频次：批处理 和 缓存。

2. Knex.js
    - https://knexjs.org/
    - npm install knex && npm install mysql
    - Knex.js是为Postgres，MSSQL，MySQL，MariaDB，SQLite3，Oracle和Amazon Redshift设计的“包含电池”SQL查询构建器，其设计灵活，便于携带并且使用起来非常有趣。它具有传统的节点样式回调以及用于清洁异步流控制的承诺接口，流接口，全功能查询和模式构建器，事务支持（带保存点），连接池 以及不同查询客户和方言之间的标准化响应。

3. axios 接口请求包
    - npm install axios
    - https://github.com/axios/axios

4. exceljs
    - npm install exceljs

5. ini 读取ini格式的配置
    - npm install ini

6. nx 是一套功能强大、可扩展的开发工具，可帮助我们开发、测试、构建和扩展 Angular 应用程序，并完全集成支持 Jest、Cypress、ESLint、NgRx 等现代库。

7. winston 日志系统

### 区块链相关的
1. ethers.js
    - https://github.com/ethers-io/ethers.js
    - https://docs.ethers.io/v5/getting-started/#getting-started--contracts
    - 开发者是 Richard Moore，并由他来创建和维护库。Ethers.js 的目的是建立“一个完整、简单、小巧的库，取代 web3 和 ethereum.js

2. web3.js
    - https://github.com/ChainSafe/web3.js
    - 是由以太坊基金会构建的开源 JavaScript 库

3. hardhat.js
    - https://github.com/nomiclabs/hardhat


#### ethers.js
- Provider：是一个类，提供了一个抽象的到以太坊网络的连接。它提供对区块链及其状态的仅读取访问。
- Signer：是一个类，以某种方式直接或间接地有权访问私人密钥，该密钥可以签署消息和交易，以授权网络向以太坊账户收取执行操作的费用。
- Contract：代表以太坊网络上特定合约的连接，应用程序可以像普通 JavaScript 对象一样使用它。
