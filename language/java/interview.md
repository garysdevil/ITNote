---
created_date: 2020-12-18
---

[TOC]

## 大学实习时的面试总结

1. 曾经：
   jsp + servlet(控制数据和业务逻辑) + javaBean
   jsp + servlet +
   DAO(vo(相当于javaBean),dao,impl(真实操作),proxy(可以进行额外操作：记录日志，方法前后),factory(可以进行单例模式的设置,可以根据值的传递实现不同的数据库操作))
   servlet调用factory获取proxy‘
   proxy实现dao接口,调用真实的操作对象impl
   impl 进行数据库的操作

2. 现在：
   MVC
   model：pojo+dao(接口)+mapper(放数据库操作语句,与dao接口对应\*.mapper文件)+service+ serviceImpl
   view：html
   controller

框架：SSM
spring：
IOC 控制反转,依赖注入。Spring中的IoC的实现原理就是工厂模式加反射机制。功能：进行所有对象的管理
AOP 切面,事务的管理

SpringMVC：
管理控制层

MyBatis：
数据库持久层，消除JDBC代码
