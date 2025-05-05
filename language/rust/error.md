---
created_date: 2022-01-29
---

[TOC]

1. 错误一

- cargo run时的错误
  ```log
  Blocking waiting for file lock on package cache
  ```
- 解决办法
  ```bash
  rm  ~/.cargo/.package-cache
  ```
