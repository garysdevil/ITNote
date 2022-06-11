[TOC]

- 参考文档
  1. https://www.cnblogs.com/yaoyaojcy/p/10367945.html
  2. https://www.cnblogs.com/wumingxiaoyao/p/7412312.html
  3. https://blog.csdn.net/zhangxueleishamo/article/details/94400572
  4. https://github.com/zabbix/zabbix/blob/master/create/src/schema.tmpl
  5. https://zabbix.org/wiki/Docs/DB_schema/3.4/triggers

## zabbix数据库表
1. hosts 表对应了主机或模板，
    - interfaceid表示这个主机所对应的监控接口类型。
    - status为0表示active，1表示disable，3表示为Template。
2. interface 表对应接口（Agent,SNMP,JMX,IPMI）。
3. items 表包含了所有主机所有模板的监控项。
    - status为0表示是启用状态。
    - templateid表示这个监控项来源于模板里的那个监控项。
4. functions表 记录了trigger中使用的表达式
5. triggers表
    - templateid表示这个触发器来源于模板里的那个触发器。
    - expression字段示范：{functionid}<阈值;触发器表达式不能同时包含有模板和主机里的监控项，并且A模板上的触发器表达式不能包含非A模板上的监控项，当触发器同时包含两台主机的item时则这个triiger会同时出现在这两台主机上。
    - status字段为0表示active，1表示disable。
    - value为0表示OK，1表示Problem，2表示UNKNOWN。
    - priority为0表示Not classified，1表示Information，2表示Warning，3表示Average，4表示High，5表示Disaster。
    - garys的推测：flags=0是自定义的触发器，=2是触发器原型，=4是触发器原型生成的触发器。
6. events表
    - source字段表示event是由什么生成的。0代表triiger，1代表discovery rule，2代表 agent auto-registration,3代表internal。（触发器事件、自动发现事件、自动注册事件、内部事件）
        + 触发器事件：触器状态发生变化时。
        + 自动注册事件：agent自动注册进server时。
        + 自动发现事件：
            ```
            Service Up       –  每当zabbix检测到active service
            Service Down  –   每当zabbix检测不到service
            Host Up  –   目标IP，至少有一个service是UP
            Host Down  –   所有的services都没响应.
            Service Discovered  –   service在维护时间之后恢复或者第一次被发现
            Service Lost  –           service在up之后丢失了
            Host Discovered  -主机在维护时间之后恢复或者第一次被发现
            Host Lost  –   主机在up之后丢失.
            ```
        + 内部事件：
            - 监控项item状态从normal变为unsupported，或者从unsupported变为normal
            - low-level发现规则状态从normal变为unsupported，或者从unsupported变为normal
            - 触发器状态从normal变为unknown，或者从unknown转为normal
        
7. hosts表和items表关联，items表和functions表关联，functions表和triigers表关联，trigger表和evetns表关联。

## 监控项整理sql语句
```sql
-- 1. 获取所有的模板名
select hostid, host as 'Template name', name as 'Visible name' from hosts where status=3;

-- -- 2. 获取某个模板/主机里所有的监控项（包含已存在的监控项，自动发现规则，自动发现规则监控项原型）
select itemid, type, hostid, name, key_, templateid from items where hostid=10001;

3. 获取某个模板/主机里所有的监控项-只包含已存在的监控项
select itemid, type, hostid, name, key_, templateid from items where hostid=10084 and itemid not in (select parent_itemid from item_discovery);

-- 3. 获取直接在主机上添加的监控项-过滤掉模板里的和通过自动发现规则添加的。
select c.itemid, c.type, c.hostid,c.name,c.key_,c.templateid from interface a inner join hosts b on a.hostid=b.hostid inner join items c on c.hostid=a.hostid where c.templateid is NULL and c.itemid not in (select itemid from item_discovery);

-- 4. 获取所有的非被链接过去的trigger
select triggerid, description, expression, status,value,priority from triggers where templateid is NULL;

-- 5. 获取某台主机上所有的触发器-过滤掉自动发现规则里面的触发器原型。
select triggerid, description, expression, status, value, priority from triggers where triggerid in (select triggerid from functions where itemid in (select itemid from items where hostid=10084)) and triggerid not in (select parent_triggerid from trigger_discovery);

-- 6. 获取模板里所有的触发器-包含触发器原型。
select triggerid, description, expression, status, value, priority from triggers where triggerid in (select triggerid from functions where itemid in (select itemid from items where hostid=10001))

-- 5. 获取trigger事件的次数，并按发生次数进行排序
select a.triggerid, a.expression, a.description, priority, count(*) cnt from triggers a , events b where a.triggerid=b.objectid and clock>时间戳 group by triggerid order by cnt desc;

-- 6. 获取所有的历史告警信息
 mysql -uzabbix -p  -e 'select message from zabbix.alerts;' > alerts.txt

-- 7. 输出至文件。
${sql} into outfile '/tmp/test.xls';
```

## 监控项整理语sql脚本
```bash
HOST=127.0.0.1
USER=root
PWD=root
PORT=3306
DB=zabbix
connect="-h${HOST} -u${USER} -p${PWD} -P${PORT} ${DB}"
getAllTemplateSql="select hostid, host as 'Template name', name as 'Visible name' from hosts where status=3"

a(){
# 输出每个模板的所有监控项-包括被链接过来的监控项
getItemSql="select hostid, itemid, type, name, key_, templateid from items where hostid="
allTemplateId=(`mysql ${connect} -N -e"select hostid from hosts where status=3"`)
for ((i=0; i<${#allTemplateId[@]}; i++));do
    hostid=${allTemplateId[$i]}
    name=`mysql ${connect} -N -e"select host from hosts where hostid=${hostid}"`
    mysql ${connect} -e"${getItemSql}${hostid}" > "${name}".xls
done
}

b(){
# 输出每个主机/模板的非被链接过来的所有触发器-主机则包含了触发器原型生成的触发器
getItemSql="select triggerid, status, priority, description from triggers where triggerid in (select triggerid from functions where itemid in (select itemid from items where templateid is NULL and  hostid=" # 10001))
allTemplateId=(`mysql ${connect} -N -e"select hostid from hosts"`)
for ((i=0; i<${#allTemplateId[@]}; i++));do
    hostid=${allTemplateId[$i]}
    name=`mysql ${connect} -N -e"select host from hosts where hostid=${hostid}"`
    mysql ${connect} -e"${getItemSql}${hostid}))" > "${name}".xls
done
}
```