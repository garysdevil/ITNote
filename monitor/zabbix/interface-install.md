### 一 Agent
1. zabix-agent

2. snmp
    - https://www.zabbix.com/documentation/3.4/manual/config/items/itemtypes/snmp
    - 关于snmp的知识 https://blog.csdn.net/bbwangj/article/details/80981098

### 二 安装zabbix-agent 3.4
```bash
# https://zabbixonly.com/how-to-install-zabbix-agent-3-4/
installInUbuntu18(){
	# 导入zabbix-agent源
	local url="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb"
	local name="zabbix-release_3.4-1+bionic_all.deb"
	wget  ${url} -O ${name}
	dpkg -i ${name}
	apt update
	# 安装
	apt-get install -y zabbix-agent
}
installInUbuntu16(){
	# 导入zabbix-agent源
	local url="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb"
	local name="zabbix-release_3.4-1+xenial_all.deb"
	wget  ${url} -O ${name}
	dpkg -i ${name}
	apt update
	# 安装
	apt-get install -y zabbix-agent
}
installInCentos7(){
    rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
	yum makecache
    yum install zabbix-agent  -y
}
config(){
    hostName=$1
	severName="XXX.XXX.XXX.XXX"
	configFile="/etc/zabbix/zabbix_agentd.conf"
	# pid
	#sed -i 's/# PidFile=\/tmp\/zabbix_agentd.pid/PidFile=\/var\/log\/zabbix\/zabbix_agentd.pid/' $configFile
	# log
	sed -i 's/LogFile=\/tmp\/zabbix_agentd.log/LogFile=\/var\/log\/zabbix\/zabbix_agentd.log/' $configFile
	# passive mode
	sed -i "s/Server=127.0.0.1/Server=${severName}/"  $configFile
	sed -i 's/ServerActive=127.0.0.1/# &/' $configFile
	sed -i "s/Hostname=Zabbix server/Hostname=${hostName}/" $configFile
    systemctl enable zabbix-agent
}
restart(){
	# /etc/init.d/zabbix-agent start 
	# service zabbix-agent restart
    systemctl restart zabbix-agent
}
init(){
flag=!`systemctl | grep zabbix-agent`
if [ X$flag != X ];then
	clientIP=`ip r | grep 'ens160 proto kernel' | awk  '{print $9}'`
    installInCentos7
    echo 'finish install'
    config $clientIP
    echo 'finish config'
    restart
    echo "finish restart agent - $clientIP"
else
	echo 'has existed zabbix-agent'
fi
}
init
```