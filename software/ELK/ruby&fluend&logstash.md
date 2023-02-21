[TOC]
## 安装ruby
- 参考 ruby.md

## fluentd
- 文档
https://github.com/fluent/fluentd
https://docs.fluentd.org/filter/record_transformer 添加新标签

1. 安装启动
```bash 
gem install fluentd
fluentd -s conf  # 生成标准配置
fluentd -c conf/fluent.conf # 启动

# 将日志输出到<match fluent-cat debug.test>上
echo '{"hello":"world"}' | fluent-cat fluent-cat debug.test
```
### fluentd插件
1. logstash-output-fluentd 用于将数据从Fluentd输出到Logstash
2. cloudwatch_logs 用于从aws的cloudwatch拉取或者发送日志
### fluentd配置
1. 安装插件 gem install cloudwatch_logs
2. 配置 
```conf
<source>
  @type forward
</source>
# 启动端口收集日志
<source>
  @type  tcp 
  @id    debug-input
  port  24221
  tag debug
  <parse>
    @type json
  </parse>
</source>

<source>
  @type cloudwatch_logs  # 使用cloudwatch_logs插件
  tag kujiu.cloudwatch_logs.in
  log_group_name fluent-plugin-cloudwatch-example
  log_stream_name fluent-plugin-cloudwatch-example
  state_file /tmp/fluent-plugin-cloudwatch-example.state
  json_handler json # 非json格式的解析为json
  fetch_interval 2 # 拉取间隔
</source>

<match test.cloudwatch_logs.out>
  @type cloudwatch_logs
  log_group_name fluent-plugin-cloudwatch-example
  log_stream_name fluent-plugin-cloudwatch-example
  auto_create_stream true
</match>

<match test.cloudwatch_logs.in> # 匹配Tag进行输出
  @type stdout # 使用内置的stdout插件
</match>
```
3. 模块介绍
source 指令确定输入源。
match 指令确定输出目的地。
filter 指令确定事件处理管道。
system 指令设置系统级配置。
label 指令将output和filter分组以进行内部路由。
@include 指令用于包括其它文件。

4. 四个默认参数介绍
@type：用于指定插件类型；
@id：指定插件 id，在输出日志的时候有用；
@label：指定分组标签，可以对日志流做批处理；
@log_level：为每一组命令设定日志级别。

## logstash
- 文档
https://github.com/elastic/logstash/tags  源码
https://www.elastic.co/cn/downloads/logstash 安装包下载
https://www.yisu.com/zixun/9201.html
- 性能
启动比fluentd慢很多

1. 裸安装 
安装java8环境
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.6.0.tar.gz
根据提示安装依赖 rvm install "jruby-9.1.12.0"
安装自己需要的插件
2. 容器方式安装
```Dockerfile
From logstash:7.6.0
USER root
RUN yum install wget -y
RUN wget https://github.com/lukewaite/logstash-input-cloudwatch-logs/releases/download/v1.0.3/logstash-input-cloudwatch_logs-1.0.3.gem
RUN logstash-plugin install logstash-input-cloudwatch_logs-1.0.3.gem
# docker build -t logstash-cloudwatch:7.6.0 -f Dockerfile .
```
```yaml
version: '3'
services:
  logstash-cloudwatch:
    image: logstash-cloudwatch:7.6.0
    container_name: logstashcloudwatch
    restart: Nerver
    # environment:
    #   - "LS_JAVA_OPTS=-Xms6g -Xmx6g"
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf:ro
```

2. 启动
bin/logstash -e 'input { stdin { } } output { stdout {} }'
或者
bin/logstash -f config/cloudwatch.conf
--config.reload.automatic
- 默认监听9600端口等待数据输入
  

3. 插件安装
logstash-plugin install 插件名
或者 
./bin/logstash-plugin install xxxx.gem
--config.reload.automatic

./bin/logstash-plugin list

4. 数据流
input | decode | filter | encode | output
### logstash配置
1. 安装cloudwatch_logs插件
wget https://github.com/lukewaite/logstash-input-cloudwatch-logs/releases/download/v1.0.3/logstash-input-cloudwatch_logs-1.0.3.gem
logstash-plugin install logstash-input-cloudwatch_logs-1.0.3.gem
2. 配置
vim 
```conf
input {
    cloudwatch_logs {
        log_group => [ "/aws/eks/" ]
        access_key_id => "" # aws IAM
        secret_access_key => "" # aws IAM
        interval => 2
        # start_position => "end"
        log_group_prefix => "true"
        add_field => {
                "[fields][operation]" => "default"
                "[fields][retention]" => "week"
        }
    }
}

filter { 
  grok{
    match => {
      # 截取-之前的字符作为fields.index字段的值
       "[cloudwatch_logs][log_stream]"  => "(?<[fields][index]>(.*)(?=-)/?)"
    }
  }
  grok{
    match => {
      # 截取group作为fields.cluster字段的值
       "[cloudwatch_logs][log_group]"  => "(?<[fields][cluster]>(?<=/aws/eks/).*(?=/cluster))"
    }
  }
  
  mutate {
    replace => { "[fields][index]" => "eks-%{[fields][index]}" }
  }
  # 提取message固定字段
  if [fields][index] == "eks-kube-scheduler" {
    grok{       
      match => {       
        "[message]" => 'on node %{HOSTNAME:[k8s.nodename]}'
      }
    }
  }
  if [fields][index] == "eks-kube-controller-manager" {
    if [message] =~ /.*kind.*/ {
      grok{       
        match => {       
          "[message]" => '(?<[k8s][kind]>(?<=/)([a-zA-Z]*)).*(?<[k8s][namespace]>(?<=namespace:[\s*])([a-zA-Z0-9\-]*)).*(?<[k8s][name]>(?<=name:[\s*])([a-zA-Z0-9\-]*)).*(?<[k8s][uid]>(?<=uid:[\s*])([a-zA-Z0-9\-]*))'
        }
      }
    }
    if [message] =~ /.*Kind.*/ {
      grok{       
        match => {       
          "[message]" => '(?<[k8s][kind]>(?<=Kind:\")([a-zA-Z]*)).*(?<[k8s][namespace]>(?<=Namespace:\")([a-zA-Z0-9\-]*)).*(?<[k8s][name]>(?<=Name:\")([a-zA-Z0-9\-]*)).*(?<[k8s][uid]>(?<=UID:\")([a-zA-Z0-9\-]*))[\",\s].*(?<[k8s][type]>(?<=type:\s\')([a-zA-Z0-9\-]*)).*(?<[k8s][reason]>(?<=reason:\s\')([a-zA-Z0-9\-]*)).*(?<[k8s][event]>(?<=\'\s)(.*))'
        }
      }
    }
  }
}
output {
  if [fields][operation] == "default" {
    if [fields][retention] == "day" {
      elasticsearch {
        hosts => ["172.31.85.248:9200"]
        index => "%{[fields][index]}-%{+YYYYMMdd}"
        timeout => 120
        validate_after_inactivity => 20000
      }
    } else if [fields][retention] == "week" {
      elasticsearch {
        hosts => ["172.31.85.248:9200"]
        index => "%{[fields][index]}-%{+YYYYww}"
        timeout => 120
        validate_after_inactivity => 20000
       }
    } else if [fields][retention] == "month" {
      elasticsearch {
        hosts => ["172.31.85.248:9200"]
        index => "%{[fields][index]}-%{+YYYYMM}"
        timeout => 120
        validate_after_inactivity => 20000
       }
    } else if [fields][retention] == "year" {
      elasticsearch {
        hosts => ["172.31.85.248:9200"]
        index => "%{[fields][index]}-%{+YYYY}"
        timeout => 120
        validate_after_inactivity => 20000
       }
    }
  }
}
```
nohup bin/logstash -f config/cloudwatch.conf 2>&1 &
```ruby
# 读取文件的日志
input {
    file {
        path => ["/var/log/*.log", "/var/log/message"]
        type => "system"
        start_position => "beginning"
  }
}
# 从标准输入读取数据
input {
    stdin {
        add_field => {"key" => "value"} # 增加字段
        codec => "plain" 
        # codec => "json"  # 使用json解析输入的数据
        tags => ["add"] # 增加一个标签
        type => "std"
    }
}

filter {
  # 删除某些数据
  #if [type] == "temp"{
  #  if [message] !~ /^[2020|2021|2019]/ {
  #      drop {} 
  #  } 
  #}
  # # 字段类型转换
  # if [request_time] {
  #   mutate{
  #     convert => ["request_time","float"]  #设置request_time的类型为float类型
  #   }
  # }
}
output {
  stdout {
    codec => rubydebug
  }
}
# 输出到文件
output { 
    file {
          # 表示年 月 日 主机
            path => "/tmp/%{+yyyy}-%{+MM}-%{+dd}-%{host}.log"
            codec => line {format => "%{message}"}
    }
}
# 服务端监听模式，默认开启
input {
  tcp {
    mode => "server"
    port => 9600
    ssl_enable => false
  }
}
```


### 插件
#### 一 gork 分割文本插件
- 
https://grokdebug.herokuapp.com/ 在线测试工具
https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html grok正则
https://www.elastic.co/cn/blog/do-you-grok-grok
正则表达式库是Oniguruma

1. 内置表达式
  - %{SYNTAX:SEMANTIC}
  SYNTAX：代表匹配值的类型
  SEMANTIC：代表存储该值的一个变量名称
  - 例如：127.0.0.1 GET /index.html 15824 0.043
  ```conf
  filter {
    grok {
      match => { "message" => "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}" }
    }
  }
  ```
2. 创建内置表达式
vim my-patterns
```ruby
MYPATTERNS [0-9A-F]{10,11}
``` 
```
filter {
  grok {
    patterns_dir => ["./my-patterns"]
    match => { "message" => "%{MYPATTERNS:my}" }
  }
}
```
3. 通过正则创建自定义表达式
```regexp
(?<field_name1>the pattern here).*(?<field_name2>the pattern here)
```

3. 表达式的匹配
  1. 不匹配则生成 _grokparsefailure 标签
  2. 使用条件来避免不匹配的信息进入gork
      if [message] !=~ /^2020/ {
        grok {}
    }
##### 实践
1. 非结构化
```log
"I1030 02:25:35.264412       1 garbagecollector.go:405] processing item [v1/Pod, namespace: default, name: writebackdbopt5-1604024640-67fz5, uid: 0342ed95-1a57-11eb-ba7b-0a89dd6aa8e1]"
```
```ruby
(?<kind>(?<=/)([a-zA-Z]*)).*(?<namespace>(?<=namespace:[\s*])([a-zA-Z0-9\-]*)).*(?<name>(?<=name:[\s*])([a-zA-Z0-9\-]*)).*(?<uid>(?<=uid:[\s*])([a-zA-Z0-9\-]*))

```

2. 字符串与json混合
```log
I1029 09:50:10.047661       1 event.go:209] Event(v1.ObjectReference{Kind:"CronJob", Namespace:"gary", Name:"gary-shipping-label-webhooknotify1100222", UID:"0985f4c3-1059-11eb-87c3-0af382b4a717", APIVersion:"batch/v1beta1", ResourceVersion:"744672123", FieldPath:""}): type: 'Normal' reason: 'SuccessfulDelete' Deleted job gary-shipping-label-webhooknotify1100222-1603964880
```
```ruby
(?<kind>(?<=Kind:\")([a-zA-Z]*)).*(?<namespace>(?<=Namespace:\")([a-zA-Z0-9\-]*)).*(?<name>(?<=Name:\")([a-zA-Z0-9\-]*)).*(?<uid>(?<=UID:\")([a-zA-Z0-9\-]*))[\",\s].*(?<type>(?<=type:\s\')([a-zA-Z0-9\-]*)).*(?<reason>(?<=reason:\s\')([a-zA-Z0-9\-]*)).*(?<event>(?<=\'\s)(.*))

```
### 二 GeoIP

## 创建IAM-拥有CloudWatch Logs相关权限
1. 创建策略kujiu-log-strategy  
    - CloudWatch Logs服务
        1. log-stream资源
        2. DescribeLogGroups、DescribeLogStreams、FilterLogEvents、GetLogEvents 操作权限。
2. 创建组kujiu-log-group -- 包含策略kujiu-log-strategy
3. 创建用户 -- 属于组kujiu-log-group
4. 获取用户的key和密钥