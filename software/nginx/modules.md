---
created_date: 2020-12-08
---

[TOC]

### GeoIP

```dockerfile
RUN apt install -y nginx nginx-module-geoip
# nginx 安装GeoIP数据库
RUN mkdir /etc/nginx/geoip
# && wget https://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz \
# # wget https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
# && wget https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz \

# 下载失败则从本copy进容器
COPY GeoIP.dat.gz  /etc/nginx/geoip/ 
RUN cd /etc/nginx/geoip/ \
&& gunzip GeoIP.dat.gz \
&& tar -xzvf GeoIP.tar.gz \
&& mv GeoIP-1.4.8 GeoIP \
&& cd GeoIP \
&& ./configure \
&& make && make install \
&& rm -rf GeoIP GeoIP.tar.gz
# && /usr/local/lib' > /etc/ld.so.conf.d/geoip.conf && ldconfig
```
