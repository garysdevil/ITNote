### ssl 和 tls 协议
```
使用的算法是不同的：ssl协议一般都是使用MAC哈希算法的，但是tls使用的是RFC-2014定义的HMAC算法.

对证书的要求是不同的：tls协议在使用的过程中一般是不需要指定的证书，但是ssl协议在使用的时候是需要指定证书的。

这两种证书最大的关系是并列关系，tls证书是一种新的协议，这种协议是建立在ssl3.0协议规范之上，是ssl3.0的后续版本.
```

### SSL双向认证
```
1 客户端的浏览器向服务器传送客户端 SSL 协议的版本号，加密算法的种类，产生的随机数，以及其他服务器和客户端之间通讯所需要的各种信息。  
2 服务器向客户端传送 SSL 协议的版本号，加密算法的种类，随机数以及其他相关信息，同时服务器还将向客户端传送自己的证书。  
3 客户利用服务器传过来的信息验证服务器的合法性，服务器的合法性包括：证书是否过期，发行服务器证书的 CA 是否可靠，发行者证书的公钥能否正确解开服务器证书的“发行者的数字签名”，服务器证书上的域名是否和服务器的实际域名相匹配。如果合法性验证没有通过，通讯将断开；如果合法性验证通过，将继续进行第四步。  
4 用户端随机产生一个用于后面通讯的“对称密码”，然后用服务器的公钥（服务器的公钥从步骤②中的服务器的证书中获得）对其加密，然后将加密后的“预主密码”传给服务器。  
5 如果服务器要求客户的身份认证（在握手过程中为可选），用户可以建立一个随机数然后对其进行数据签名，将这个含有签名的随机数和客户自己的证书以及加密过的“预主密码”一起传给服务器。  
6 如果服务器要求客户的身份认证，服务器必须检验客户证书和签名随机数的合法性，具体的合法性验证过程包括：客户的证书使用日期是否有效，为客户提供证书的CA 是否可靠，发行CA 的公钥能否正确解开客户证书的发行 CA 的数字签名，检查客户的证书是否在证书废止列表（CRL）中。检验如果没有通过，通讯立刻中断；如果验证通过，服务器将用自己的私钥解开加密的“预主密码”，然后执行一系列步骤来产生主通讯密码（客户端也将通过同样的方法产生相同的主通讯密码）。  
7 服务器和客户端用相同的主密码即“通话密码”，一个对称密钥用于 SSL 协议的安全数据通讯的加解密通讯。同时在 SSL 通讯过程中还要完成数据通讯的完整性，防止数据通讯中的任何变化。  
8 客户端向服务器端发出信息，指明后面的数据通讯将使用的步骤7中的主密码为对称密钥，同时通知服务器客户端的握手过程结束。  
9 服务器向客户端发出信息，指明后面的数据通讯将使用的步骤7中的主密码为对称密钥，同时通知客户端服务器端的握手过程结束。  
10 SSL 的握手部分结束，SSL 安全通道的数据通讯开始，客户和服务器开始使用相同的对称密钥进行数据通讯，同时进行通讯完整性的检验。  

单向认证模式与双向认证模式的区别，就在于第5、第6步是否要求对客户的身份认证。单向不需要认证，双向需要认证。

```

### 生成自签名

.key格式：私有的密钥
.csr格式：证书签名请求（证书请求文件），含有公钥信息，certificate signing request的缩写
.crt格式：证书文件，certificate的缩写
.crl格式：证书吊销列表，Certificate Revocation List的缩写
.pem格式：用于导出，导入证书时候的证书的格式，有证书开头，结尾的格式

https://blog.csdn.net/moakun/article/details/80631369?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.edu_weight&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.edu_weight

https://www.cnblogs.com/lixianguo/p/12522557.html

https://www.cnblogs.com/yelao/p/9486882.html

```bash
#!/bin/bash
# function: 创建 nginx https ,双向认证证书
#
# BEGIN
#
# 网站域名
# 在签发服务(客户)端证书的时候
# 这个域名必须跟 subj 中的 CN 对应
# 否则浏览器会报不安全的链接
# 查找所有me-api-stg.garys.top替换成域名运行即可
domain="me-api-stg.garys.top"
#
# ---------- CA ----------
#
# 准备CA密钥
echo "创建CA密钥.."
openssl genrsa -out $domain.CA.key 2048
# 生成CA证书请求
# 证书请求都是根据私钥来生成的
echo "生成CA证书请求.."
openssl req -new -key $domain.CA.key -out $domain.CA.csr -days 365 -subj /C=CN/ST=GuangDong/L=GuangZhou/O=${domain}/OU=${domain}/CN=opcenter/emailAddress=${domain} -utf8
 
# 签名CA证书请求
# 使用自己的私钥来给这个CA证书请求签名
# 经过多次测试得知: 这个时间如何设置的太长,如 3650(10年) 
# chrome浏览器会报, 该网站使用的安全设置已过期
# 所以https不会显示是绿色, 而是带一个黄色三角形的图标
# 奇怪的是: 如果设成1年,也就是365天,不会提示该网站使用的安全设置已过期
# 而且也是绿色的标识
# 但如果是2年, 也是绿色的标识,但是会提示该网站使用的安全设置已过期
# 这个应该chrome浏览器的问题
echo "创建CA证书.."
openssl x509 -req -in $domain.CA.csr -signkey $domain.CA.key -out $domain.CA.crt -days 365
 
# CA证书转换为DER格式,
# DER格式似乎更加通用
openssl x509 -in $domain.CA.crt -out $domain.CA.der -outform DER
# 现在, 终于拿到了自己做 CA 需要的几个文件了, 
# 密钥: $domain.CA.key
# 证书: $domain.CA.crt
# 系统使用的: $domain.CA.der
# 接下来, 要创建一个网站, 就需要让 CA 给他签名一个证书了
 
#
 # --------- SERVER ----------
 #
 # 准备网站密钥
 echo "创建网站(服务端)密钥.."
 openssl genrsa -out $domain.server.key 2048
 # 生成网站证书请求
 # CN 一定要是网站的域名, 否则会通不过安全验证
 echo "生成网站(服务端)证书请求.."
 openssl req -new -key $domain.server.key -out $domain.server.csr -days 365 -subj /C=CN/ST=GuangDong/L=GuangZhou/O=${domain}/OU=${domain}/CN=$domain/emailAddress=${domain} -utf8
  
# CA签名网站证书请求
# 不是拿到 CA 的证书了就可以说自己是 CA 的, 最重要的是, 签名需要有 CA 密钥
# 如果客户端（个人浏览器）信任 CA 的证书的话, 那么他也就会信任由 CA 签名的网站证书
# 因此让浏览器信任 CA 的证书之后, 客户端就自然信任服务端了, 只要做单向认证的话, 到这一步证书这一类材料就已经准备好了
# 但是双向认证就还要给客户端（个人的浏览器）准备一份证书
# 让服务端可以知道客户端也是合法的。
# 假如让服务端也信任 CA 的证书
# 那 CA 签名的客户端证书也就能被信任了。
echo "通过CA证书签名, 创建网站(服务端)证书.."
openssl x509 -req -in $domain.server.csr -out $domain.server.crt -CA $domain.CA.crt -CAkey $domain.CA.key -CAcreateserial -days 365
   
#
# --------- CLIENT ----------
#
# 准备客户端私钥
echo "创建浏览器(客户端)密钥.."
openssl genrsa -out $domain.client.key 2048
# 生成客户端证书请求
echo "生成浏览器(客户端)证书请求.."
openssl req -new -key $domain.client.key -out $domain.client.csr -days 3650 -subj /C=CN/ST=GuangDong/L=GuangZhou/O=${domain}/OU=${domain}/CN=$domain/emailAddress=${domain} -utf8
# CA签名客户端证书请求
echo "通过CA证书签名, 创建浏览器(客户端)证书.."
openssl x509 -req -in $domain.client.csr -out $domain.client.crt -CA $domain.CA.crt -CAkey $domain.CA.key -CAcreateserial -days 365 
# 客户端证书转换为DER格式
openssl x509 -in $domain.client.crt -out $domain.client.der -outform DER
# 客户端证书转换为 PKCS, 即12格式
# 全称应该叫做 Personal Information Exchange
# 通常以 p12 作为后缀
echo "转换客户端证书为p12格式.."
openssl pkcs12 -export -in $domain.client.crt -inkey $domain.client.key -out $domain.client.p12 -password pass:123456
# openssl pkcs12 -in $domain.client.p12 -out all.pem -nodes 
# -nodes 不加密私钥
```
#### 最简单的方式生成自签名证书
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/nginx/ssl/nginx.key -out /usr/local/nginx/ssl/nginx.crt
req 表示想使用 X.509 certificate signing request (CSR) 进行管理
-x509 表示使用自签名证书代替在线 CSR 请求。

### 验证
1. 双向认证校验
```bash
curl  -k --cert ./$domain.client.crt --key ./$domain.client.key https://$domain
curl  -k --key ./all.pem https://$domain

```

### 自签名和权威机构授权 
#### 如何才能不让信息在途中被第三方看到看到和被修改
1. 通过对称加密，客户端告诉服务端我们之间要传送信息，服务端发送密钥给客户端，然后彼此间通过密钥加密信息后进行传输。
（双方的信息都是被加密过的）（密钥传输中就被攻击者截取）（密文与明文字节数基本相等）

2. 通过非对称加密，服务端发送公钥给客户端，客户端加密信息发送给服务端。（只有客户端的信息是加密过的）
（只有一方的信息被加密了，非对称密钥对加密报文的信息长度是有要求的）（公钥传输中就被攻击者截取篡改）（密文字节数大于明文）（加密解密速度极慢）

3. 通过 对称加密 和 非对称加密 两种混合方式。
（公钥传输中就被攻击者截取篡改）

#### 私钥+公钥的混合加密模式任然存在第一次公钥可能被中间人截获的风险
- 解决方案：
1. 方案一 游览器保存所有服务端的公钥。
2. 方案二 通过权威机构
  1. 设置权威机构的原因是因为游览器不可能保存所有服务器的公钥。 
  2. 游览器只保存几个权威的网站的公钥。 
  3. 服务器向权威网站申请证书。
  4. 校验：游览器使用权威机构公钥解密证书得到证书签名，并使用hash生成证书签名，得到的证书签名一致，则再使用权威机构公钥解密出服务端的公钥。