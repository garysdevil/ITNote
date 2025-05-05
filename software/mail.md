---
created_date: 2024-11-05
---

[TOC]

## IMAP POP SMTP

- IMAP 和 POP 是访问电子邮件的两种方法。
- IMAP
  - Internet Mail Access Protocol
  - 工作原理是连接电子邮件服务读取新邮件；客户端和电子邮件服务是双向通信的，客户端的操作都会反馈到服务器上。这意味着，你可以从世界上任何地方的不同设备检查电子邮件。
  - 仅在单击邮件时下载邮件，附件不会自动下载。 这样，就可以比 POP 更快地检查邮件。
- POP3
  - Post Office Protocol 3
  - 工作原理是连接电子邮件服务，下载所有新邮件，从电子邮件服务中删除被下载过的邮件。 这意味着，在下载电子邮件后，只能使用同一台计算机对其进行访问。
  - 已发送邮件存储在本地电脑上，而不是存储在电子邮件服务器上。
- SMTP
  - Simple Mail Transfer Protocol

## Gmail

1. 开启IMAP

   1. https://mail.google.com/mail/u/0/#settings/fwdandpop

2. 生成应用密码

   1. 需要先开启两步验证
   2. https://security.google.com/settings/security/apppasswords
   3. 生成应用密码后需要立刻复制记录下来，应用密码窗口关掉后就不能再次查看了。
