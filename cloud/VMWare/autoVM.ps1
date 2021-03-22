Function init{
    #1. PowerShell的Vsphere相关模块下载地址 https://my.vmware.com/web/vmware/details?downloadGroup=PCLI650R1&productId=614
    #2. 请先在PowerShell里安装VMware PowerCLI相关模块

    #CLIPath="C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\"
    #cd $CLIPath
    #./Initialize-PowerCLIEnvironment_Custom.ps1.ps1
    Import-Module VMware.PowerCLI
    Connect-VIServer ${IP}
}
# 此教程基于VMware PowerCLI 6.5 编写而成 
#　设置选择excel里的IP数量, 从Start到End-1
$Start = 0
$End = 60

# 选择集群，存储，被克隆的机器，文件夹,网卡
$Cluster = 'cluster'
$Datastore = 'vsanDatastore'
$VMCloneName = "Template_Ubuntu18.04_Platone"
$VMFolder = "platoneE_50"
#New-folder -Name $VMFolder -Location 'VM'
$NetworkAdapter = 'Vlan251'

#　定义网关地址，定义DNS, 网络配置文件的位置
$GATEWAY = "${IP}"
$DNS1 = "${IP}"
$IPFilePath = "/etc/sysconfig/network-scripts/ifcfg-ens160"
#$IPFilePath = "/etc/netplan/50-cloud-init.yaml"

# 从csv里读取 IP,虚拟机的名字， 虚拟机系统的名字
$csvPath = "C:\xsg\ipStatic.csv"
$StaticIpList = Import-CSV $csvPath | foreach { $_.IP}
$VMNameList = Import-CSV $csvPath | foreach { $_.VMName}
$SystemNameList = Import-CSV $csvPath | foreach { $_.SystemName}
 
Function createVM(){
    for($i = $Start; $i -lt $End; $i ++) {
        New-VM -VM $VMCloneName -Name $VMNameList[$i] -resourcepool $Cluster -Location $VMFolder  -Datastore $Datastore  
        # 克隆虚拟机需要消耗较长的时间
        Sleep 20
    }
    for($i = $Start; $i -lt $End; $i ++) {
        Start-VM -VM $VMNameList[$i]
    }
    Sleep 60
    echo 'finish create VM'
}
# 重新配置机器的内核，内存；网卡
Function setVM(){
    for($i = $Start; $i -lt $Total; $i ++) {
        Set-VM $VMNameList[$i] -NumCpu 2 -MemoryGB 4 -Confirm:$false
        Get-VM $VMNameList[$i] | New-NetworkAdapter -NetworkName $NetworkAdapter -StartConnected:$true -WakeOnLan:$true -Confirm:$false
        Sleep 3
    }
    Sleep 10
    for($i = $Start; $i -lt $Total; $i ++) {
         Start-VM -VM $VMNameList[$i]
         Sleep 3
    }
    Sleep 60    
    echo 'finish set VM'
}
# 在虚拟机内部 进行网络配置，系统名称修改
Function configVMCentOS(){
    for($i = $Start; $i -lt $Total; $i ++) {
        $SystemName = $SystemNameList[$i]
        $IPADDR = $StaticIpList[$i]
        $IPSettingText = "TYPE=Ethernet\n BOOTPROTO=static\n ONBOOT=yes\n IPADDR=$IPADDR\n PREFIX=24\n GATEWAY=$GATEWAY\n DNS1=$DNS1\n"
        $script1 = "echo -e  '$IPSettingText' > $IPFilePath && systemctl restart network"
        $script2 = "hostnamectl set-hostname $SystemName"
        $script = "$script1 && $script2"
        Invoke-VMScript -ScriptText "$script"  -GuestUser 'root' -GuestPassword 'XXXXXX' -VM $VMNameList[$i] -Confirm:$false
    }
    echo "finish set IP"
}
# 在虚拟机内部 进行网络配置，系统名称修改
Function configVMUbuntu18(){
    for($i = $Start; $i -lt $End; $i ++) {
        $SystemName = $SystemNameList[$i]
        $IPADDR = $StaticIpList[$i]

        $script1 = "sed -i s/${IP}/${IPADDR}/g $IPFilePath ; ip addr flush ens160 ; netplan apply"
        $script2 = "hostnamectl set-hostname $SystemName && systemctl restart ntp"
        $script = "$script1 && $script2"
        Invoke-VMScript -ScriptText "$script1"  -GuestUser 'root' -GuestPassword 'XXXXXX' -VM $VMNameList[$i] -Confirm:$false
    }
    echo "finish set IP"
}
#　批量删除虚拟机
Function deleteVM(){
    for($i = $Start; $i -lt $End; $i ++) {
        $VM = get-vm $VMNameList[$i]
        if ($VM.PowerState -eq "Poweredon") {
            Stop-VM  $VMNameList[$i] -confirm:$false   
         }
    }
    Sleep 30 
    for($i = $Start; $i -lt $End; $i ++) {
         Remove-vm  $VMNameList[$i] -confirm:$false -deletepermanently   
    }
    echo "finish sdelete VM"
}
Function createAndConfig() {
    createVM
    configVMUbuntu18
}
createAndConfig

