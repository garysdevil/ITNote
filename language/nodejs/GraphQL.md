---
created_date: 2020-11-16
---

[TOC]

# GraohQL
- 参考
    - https://github.com/graphql/graphiql
    - https://graphql.org/learn/
    - https://graphql.cn/

- 数据传输风格
    - RPC
    - REST
    - GraphQL

1. 前端可以 一次性取取完所有需要的数据（可以获取多个接口的数据，可以选择性地获取接口中的字段)

2. 解决 前端产品快速迭代对API的更改。解决不同的客户端对数据的不同需求。

3. 使用强大的Type System来定义API的功能，所有的API中公开类型都是使用GraphQL

## SDL
- schema Definition Language(SDL)该模式充当客户端和服务器之间的契约，以定义客户机如何访问数据。
    - query
    - mutation
    - subscription

### 查询
```graphql
query {
  # 刷选id等于5的数据
  approvalForAlls(id: 5) {
    id
    owner
    operator
    approved
  }
    # first 读取100条数据
    # skip 跳过前1000条数据
    # orderBy 根据某个字段进行排序
    # orderDirection，desc倒序，abs正序，默认正序
  transfers(first: 100, skip: 1000, orderBy: tokenId, orderDirection: asc) {
    id
    from
    to
    tokenId
  }
}
```