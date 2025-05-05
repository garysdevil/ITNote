---
created_date: 2022-12-13
---

[TOC]

- 公众号接入微信企业提供的人工智能
  - https://openai.weixin.qq.com/
  - https://github.com/wechaty/wechaty-weixin-openai
  - 参考 http://t.zoukankan.com/juemuren4449-p-12382809.html

- 后台如何接入微信公众号 
    - https://help.weimengcms.com/html/admin/article/154.html
    - https://www.liaoxuefeng.com/article/929799249853600


## 微信接入openai
- https://github.com/fuergaosi233/wechat-chatgpt
```bash
image_version=0.0.3
docker run -d --name wechat-chatgpt -v $(pwd)/config.yaml:/app/config.yaml holegots/wechat-chatgpt:${image_version}
```