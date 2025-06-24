---
created_date: 2020-11-16
---

[TOC]

- GraohQL

## 链接

- https://github.com/graphql/graphiql
- https://graphql.org/learn/
- https://graphql.cn/

## 简介

- 数据传输风格
  1. RPC
  2. REST
  3. GraphQL
- GraphQL的优势
  1. 前端可以一次性获取所有需要的数据（可以获取多个接口的数据，可以选择性地获取接口中的字段）
  2. 解决前端产品快速迭代对API的更改。解决不同的客户端对数据的不同需求。

## SDL

- Schema Definition Language (SDL) 是 GraphQL 提供的一种语法，用于以声明式的方式定义 GraphQL API 的 schema。
- SDL 使用一种人类可读的格式，描述数据类型、查询（query）、变更（mutations）、订阅（subscriptions）以及它们之间的关系

### 示范一

```graphql
# 查询操作
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

### 示范二

```graphql
# 定义类型
type Transfer @entity(immutable: true) {
  id: Bytes!
  from: Bytes! # address
  to: Bytes! # address
  tokenId: BigInt! # uint256
  blockNumber: BigInt!
  blockTimestamp: BigInt!
  transactionHash: Bytes!
}
type Query {
  transfers(first: Int, skip: Int, where: TransferFilter): [Transfer!]!
}
```

```graphql
# 查询操作
query {
  transfers(where: { from: "0xsfsdfsdfsdfsdfff" }) {
    id
    from
    to
    tokenId
  }
}
```
