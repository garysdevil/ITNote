- 参考
    1. https://zhuanlan.zhihu.com/p/80909555
    2. https://freessl.cn/
    3. https://blog.csdn.net/ithomer/article/details/78075006

./certbot-auto certonly -d "*.domain.com" --manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --no-bootstrap