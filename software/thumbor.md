---
created_date: 2021-03-29
---

[TOC]

1. github\
   https://github.com/thumbor/thumbor

2. document
   https://thumbor.readthedocs.io/en/latest/index.html

3. docker

   - https://registry.hub.docker.com/r/minimalcompact/thumbor
   - challengesoft/thumbor-gcloud
   - docker run -p 8888:80 minimalcompact/thumbor

4. using

```powershell
# 
encodedURI=window.encodeURIComponent(
  "https://garys.top/PMQ/static/admin/images/login-backgroud.png"
)
console.log(encodedURI)

# 剪裁图片
http://127.0.0.1:8888/unsafe/300x200/https%3A%2F%2Fgarys.top%2FPMQ%2Fstatic%2Fadmin%2Fimages%2Flogin-backgroud.png
```

5. cloud-storage

   - https://github.com/Superbalist/thumbor-cloud-storage
   - https://www.cnpython.com/pypi/thumbor-cloud-storage
   - pip install thumbor-cloud-storage

6. s3

   - https://github.com/thumbor-community/aws
