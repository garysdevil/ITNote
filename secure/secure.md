## 相关链接
### 安全学习训练平台
1. bWAPP
    - www.itsecgameses.com
    - 免费和开源的web应用程序安全项目。有助于安全爱好者及研究人员发现和防止web漏洞。

2. DVIA
    - damnvulnerableiosapp.com
    - 一个IOS的安全应用。给移动安全爱好者学习IOS的渗透测试技巧提供一个合法的平台。

3. DVWA
    - dvwa.co.uk
    - 基于php和mysql的虚拟Web应用。内置常见的Web漏洞，如SQL注入、xss之类，可以搭建在自己的电脑上。

4. Game of Hacks
    - www.gameofhacks.com
    - 基于游戏的方式来测试你的安全技术。每个任务题目提供了大量的代码，其中可能有也可能没有安全漏洞。

5. Google Gruyere
    - -
    - 一个看起来很low的网站，但充满了漏洞，目的是为了帮助那些刚开始学习应用程序安全性的人员。

6. HackThis
    - defendtheweb.net
    - 教你如何破解、转储和涂改以及保护网站的黑客技巧，提供超过50种不同的难度水平。

7. Hack This Site
    - www.hackthelsslte.org
    - 一个合法和安全的测试黑客技能的网站，并包含黑客咨询、文章、论坛和教程，旨在帮助你学习黑客技术。

8. Hellbound Hackers
    - hbh.sh/home
    - 提供各种各样的安全实践方法和挑战，目的是教你如何识别攻击和代码的补丁建议。主题包括应用程序加密和破解，社工和rooting。
    - 社区有接近10万的注册成员，是最大的一个黑客社区之一。

9. McAfee HacMe Sites
    - https://www.mcafee.com/enterprise/en-us/downloads/free-tools.html
    - 提供各类黑客及安全测试工具。

10. Mutillidae
    - sourceforge.net/projects/mutillidae
    - 是一个免费，开源的Web应用程序。提供专门被允许的安全测试和入侵的Web应用程序，其中包含了丰富的渗透测试项目，如SQL注入、跨站脚本、clickjacking、本地文件包含、远程代码执行等。

11. OverTheWire
    - overthewire.org/wargames
    - 基于游戏的让你学习安全技术和概念的黑客网站。

12. Try2Hack
    - 最古老的黑客网站之一，提供多种安全挑战。

13. i春秋
    - ichunqiu.com/maim
    - 中国比较好的安全知识和线上学习平台，把复杂的操作系统、工具和网络环境完全的在网页进行重现。

14. XCFT_OJ
    - adworld.xctf.org.cn
    - 中国安全练习平台，汇集全世界CTF网络安全竞赛的真题题库。
    - 目前全球CFT社区唯一一个提供赛题重现复盘练习环境的站点资源。

15. HawkEye鹰眼系统
    - hackingglab.cn/index.php
    - 网络信息安全攻防学习平台。提供基础知识考查、漏洞实战演练、教程等资料。实战演练以Web题为主。
### 其它
- 网站克隆工具httrack http://httrack.kauler.com/help/Form-based_authentication

## 常见的攻击方法
1. KeyLogger 键盘监听
2. DDOS Attack (Distributed Denal of Service)
3. Waterhole Attack 水坑式攻击
4. Fake WAP 虚假网页
5. Eavesdropping 网络窃听
6. Phishing 网络钓鱼
7. Virus 病毒
8. Clicjjacking 点击劫持
9. Cookie theft 窃取Cookie
10. Bait and Switch 诱取和开关

### DDos
- 定义： 通过占用服务的网络资源、连接资源，让服务应接不暇，从而拒绝正常的流量。

#### 针对IP
1. ICMP flood
    - 通过发送ICMP协议数据包，占用目标的带宽资源。
    - ping产生的是ICMP协议包，ICMP是IP协议中用来进行差错控制的一个补充

#### 针对UDT协议
2. UDT flood
    - 通过发送UDT数据包，占用目标的带宽资源。
    - UDT flood增强版
        1. IP伪造
            - 更改数据包的发送地址。
        2. 反射攻击
            - 更改数据包的接收地址。将数据包发送到第三方机器，第三方机器向接收地址回复数据包。
            - 第三方机器也被称之为“反射器”。
        3. 放大器
            - 当“反射器”接收到数据包时，会返回更大的数据包。

#### 针对TCP协议
1. TCP flood
    - 通过和目标构建大量的TCP连接，从而占满目标机器上的TCP连接表。

2. SYN flood
    - 通过伪造IP/反射器，然后发送给目标机器SYN建立连接的数据包，然后不回复对方的SYN+ACK数据包息，由于TCP里的重传机制，目标机器将多次尝试发送SYN+ACK数据包直到超时。

3. RST flood
    - TCP协议中，一般用4次挥手结束连接，为了防止出现异常，一方可以发送一个RST数据包进行强制切段连接
    - 伪造各种IP地址，发送RST数据包给目标机器，一旦伪造的IP和其它的一些配置和某个正常用户匹配上，就能能够切断正常用户和服务器之间的连接。
    - 例如在一场网络游戏对战中，在获悉对手的IP地址之后，就可以通过此种方式不断切段对手的游戏设备和服务器间的连接，以干扰对方玩家的操作。

#### 针对HTTP协议
1. HTTP flood
    - 通过对网站进行特定的访问，使用目标服务并发执行大量的业务代码，从而消耗目标服务器的CPU或内存或IO。例如业务代码可能会执行数据库查询这样的IO操作。
    - 建立了TCP连接，因此不能伪造IP地址，因此需要zombie机器。

### 防DDos
1. 网络设备IP过滤（涉及到用户、服务商、设备商、监管部门，因此难以实现）
    - 路由器将数据包源地址IP本不属于所在网络段的数据包都过滤掉。

2. 通过CDN技术

3. 流量清洗设备