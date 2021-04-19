
- Google Cloud Application Default Credentials (ADC) 

### 以服务帐号身份进行身份验证
- 参考
    - https://www.jhanley.com/google-cloud-application-default-credentials/
    - https://cloud.google.com/docs/authentication/production#auth-cloud-implicit-python

1. 如果设置了环境变量 GOOGLE_APPLICATION_CREDENTIALS，则 ADC 会使用该变量指向的服务帐号文件。

2. 如果未设置环境变量 GOOGLE_APPLICATION_CREDENTIALS，则 ADC 使用关联到运行代码的资源的服务帐号。  

3. 如果未设置环境变量 GOOGLE_APPLICATION_CREDENTIALS，且运行代码的资源未关联任何服务帐号，则 ADC 使用 Compute Engine、Google Kubernetes Engine、App Engine、Cloud Run 和 Cloud Functions 提供的默认服务帐号。

4. 默认服务账号文件 $HOME/.config/gcloud/application_default_credentials.json


### 权限操作
```bash
gcloud iam service-accounts create ${service_account}

gcloud iam service-accounts list

gcloud projects add-iam-policy-binding ${project_id} --member="${service_account_email}" --role="roles/owner"

gcloud iam service-accounts get-iam-policy ${service_account_email}

gcloud iam service-accounts keys create ${file_name}.json --iam-account=${service_account_email}
```