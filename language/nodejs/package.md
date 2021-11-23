## 内置包
```js
// base64加解密
var b = new Buffer.from('JavaScript');
var s = b.toString('base64');

var b = new Buffer.from('编码后的base64字符串', 'base64')
var s = b.toString();

// 将字符串解析问json对象
JSON.parse(stringvar))

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