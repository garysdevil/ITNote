---
created_date: 2020-11-16
---

[TOC]


### Minio
官网文档
https://docs.minio.io/docs/minio-admin-complete-guide.html

minio的客户端mc
https://dl.min.io/client/mc/release/linux-amd64/mc

1. 设置存储桶的访问权限(none, download, upload, public)
mc policy set download minio/test/
2. 查看存储桶当前权限
mc policy ls minio/test/

3. 列出所有的桶
mc list minioServer名称

4. 查看配置 
mc config host list
配置文件目录 /用户家目录/.mc
