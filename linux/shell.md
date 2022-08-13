
[TOC]

- shell
### 数组长度
```bash
#!/bin/bash
array_name=(
  "137.184.202.162:4132"
  "218.17.62.53:4132"
  "141.95.85.71:4132"
)
# 输出数组长度
echo ${#array_name[*]}
echo ${#array_name[@]}
# 输出数组所有的值
echo ${arr[@]} 
#  遍历数组
for ipport in ${array_name[@]};do
    echo $ipport;
done
```

### 变量的提取和替换
```bash
${var#*/} # 去掉变量var从左边算起的第一个'/'字符及其左边的内容
${var##*/} # 去掉变量var从左边算起的最后一个'/'字符及其左边的内容
${var%/*}
${var%/*}
for name in `ls *.Linux`;do mv $name ${name%.*};done
```

### 变量字符串分割
```bash
    # 分割ip和端口号
    ipport="127.0.0.1:8080"
    ip=${ipport%:*}
    port=${ipport#*:}
    echo "${ip} ${port}"
```

### 去掉字符串两边的双引号
```bash
    echo '"127.0.0.1:8080"' > ipport.txt
    
    ipport_raw=$(cat ipport.txt)
    # 去掉两边的双引号
    len_temp_1=${#ipport_raw}
    len_temp_2=$(echo "${len_temp_1}-2" | bc -l)
    ipport=${ipport_raw:1:${len_temp_2}}
    echo $ipport
```

### 判断/比较符号
```
-e filename 如果 filename存在，则为真
-d filename 如果 filename为目录，则为真 
-f filename 如果 filename为常规文件，则为真
-L filename 如果 filename为符号链接，则为真
-r filename 如果 filename可读，则为真 
-w filename 如果 filename可写，则为真 
-x filename 如果 filename可执行，则为真
-s filename 如果文件长度不为0，则为真
-h filename 如果文件是软链接，则为真
filename1 -nt filename2 如果 filename1比 filename2新，则为真。
filename1 -ot filename2 如果 filename1比 filename2旧，则为真。
-eq 等于
-ne 不等于
-gt 大于
-ge 大于等于
-lt 小于
-le 小于等于
```
```bash
#!/bin/bash
source /etc/profile
if [ $num -gt 182 ]; then
    touch "$num"
fi
```

### linux select 指令建立菜单
```bash
#!/bin/bash 

fruits=( 
"apple" 
"pear" 
"orange" 
"watermelon" 
) 

# echo "Please guess which fruit I like :" 
# select var in ${fruits[@]} 
# do 
# if [ $var = "apple" ]; then 
#     echo "Congratulations, you are my good firend!" 
#     break 
# else 
#     echo "Try again!" 
# fi 
# done 

select var in ${fruits[@]} 
do 
case $var in
    "apple"|"pear"|"orange") echo "123";break;
    ;;
    "watermelon")
    echo "4" 
    ;;
    *)
    echo "5"
    exit 1 
    ;; 
esac
done 

```

### wait
```bash
#!/bin/bash
echo "1"
sleep 5 &
echo "3"
echo "4"
wait    # 会等待wait所在bash上的所有子进程的执行结束，本例中就是sleep 5这句
echo "5"
```