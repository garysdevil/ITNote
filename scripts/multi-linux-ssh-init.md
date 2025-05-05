---
created_date: 2020-11-16
---

[TOC]

```bash
#!/bin/bash

# No secret login
login(){
file='/home/centos/.ssh/authorized_keys'
#file='/root/.ssh/authorized_keys'
command="mkdir /home/centos/.ssh/; echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3cdqwFtaB7y8tBJ6wRt10R11CTNkWmtoPv1jW5WZNlp0mxEvmhT/S7ARAGbRNDSpdq6UoWs97L6F1UwURLtHzZ5g6iKApYdZRTIQgSq1VQ2TmqjIJ8V1dZOUw2aALYwJkIqy2WhRN5fleHSP6rktWpw2q1IZv12JeLukMlDjq+EBOp0TtkRaaek8pwruXsEf+VkBTkEPEhwP4AVghqLPtBN2ta+NKtfFGr3CDW7kAzTDCwl1hrlvHhzK5VN81fG035HAJqPnPqfXx1HwF0i0EEApr/7BFrcC2gKuZZLSC7eg1KEE2i0JXXX.XXX.XXX.XXXxxxx centos@${IP}' >> ${file}"

ssh -i 1-1-1-1.pem root@1.1.1.1  $command
}

init(){
loginuser='centos'
command_fdisk="sudo fdisk /dev/nvme1n1 < fdisk.txt && sudo partprobe"
command_lvm="sudo yum -y install lvm2 && sudo pvcreate /dev/nvme1n1p1 && sudo vgcreate  vg_data  /dev/nvme1n1p1 && sudo lvcreate -n lv_data -L  199.99G  vg_data && sudo mkfs.xfs /dev/vg_data/lv_data"
command_mount="sudo mkdir /data ;  echo '/dev/vg_data/lv_data   /data   xfs    defaults    0  0' | sudo tee -a /etc/fstab && sudo mount -a && sudo df -hT"
command_mkdir="sudo mkdir /data/chain; sudo chown -R centos.centos /data; ls -l /data"

ip_arrays=(1.1.1.1 2.2.2.2)
seq=0
for ip in ${ip_arrays[@]} ;do
  let seq+=1
  #scp fdisk.txt ${loginuser}@$ip:~/
  #ssh ${loginuser}@$ip "$command_fdisk && $command_lvm && $command_mount"
  ssh ${loginuser}@$ip "$command_mkdir"
  echo -e "${seq} finished===================================$ip"
done
}
init
```
