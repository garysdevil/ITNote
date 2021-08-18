# 安装jenkins
# https://jenkins.io/download/

## 0 通过tomcat安装
```bash
# - 参考 官网：http://tomcat.apache.org/
wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz
tar xf apache-tomcat-8.5.31.tar.gz -C /usr/local/
cd /usr/local/
ln -sv apache-tomcat-8.5.31 tomcat
# - 将war包放入tomcat下的webapps目录下
sh startup.sh
# 访问：http://ip:端口/jenkins
```

## 1 通过war安装
- 参考 https://jenkins-zh.cn/tutorial/get-started/install/war/

curl -O http://mirrors.jenkins.io/war-stable/latest/jenkins.war
- 启动
export JENKINS_HOME=~/.jenkins_home
nohup java -jar jenkins.war --httpPort=8899  > /tmp/jenkins.log 2>&1 &

## 2 通过rpm安装 
curl -O https://pkg.jenkins.io/redhat/jenkins-2.176.3-1.1.noarch.rpm
rpm -ih jenkins-2.176.3-1.1.noarch.rpm

## 3 通过yum安装
curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo 
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins

## 2，3然后
更改端口 vi /etc/sysconfig/jenkins
修改Jenkins启动配置文件   vi /etc/init.d/jenkins  
service jenkins start
卸载
    # yum -y remove jenkins
    # rm -rf /var/cache/jenkins
    # rm -rf /var/lib/jenkins/
http://ip:8080/exit
http://ip:8080/restart
http://ip:8080/reload


## 忘记免密：
$JENKINS_HOME/users/用户名/config.xml
将密码更改为123456
 <passwordHash>#jbcrypt:$2a$10$MiIVR0rr/UhQBqT.bBq0QehTiQVqgNpUGyWW2nJObaVAM/2xSQdSq</passwordHash>

## Jenkins所有插件.hpi下载
https://updates.jenkins-ci.org/download/plugins/

# 其它
## 权限管理
1. 安装插件 Role-based Authorization Strategy
2. 在 Configure Global Security 中授权策略选择 Role-Based Strategy

## 
- SSH Pipeline Steps   
    - https://github.com/jenkinsci/ssh-steps-plugin
    - https://www.jenkins.io/doc/pipeline/steps/ssh-steps/#sshcommand-ssh-steps-sshcommand-execute-command-on-remote-node