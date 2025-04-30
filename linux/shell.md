
[TOC]

- shell

### 变量
```bash
# 整数
a=10
b=5
sum=$((a + b)) # 可以使用 expr 或 $(( )) 进行整数计算

# 浮动数
a=3.14
b=1.5
result=$(echo "$a + $b" | bc) # Shell 本身不直接支持浮动数的变量，但你可以使用外部命令如 bc、awk 或 printf 来进行浮动数运算
echo $result

# 数组
arr=("apple" "banana" "cherry")
echo ${arr[0]}  # 输出 apple
echo ${arr[@]}   # 输出 apple banana cherry

# 关联数组
# 从bash 4.x 开始，Shell支持关联数组（类似于字典或哈希表），可以通过字符串键来访问数组值。
declare -A fruit
local -A fruit_local # 声明一个局部的关联数组
fruit["apple"]="red"
fruit["banana"]="yellow"
echo ${fruit["apple"]}   # 输出 red
```

```sh
# 普通数组作为关联数组的键
#!/bin/bash

# 声明一个普通数组
arr=("1" "2" "3")

# 声明一个关联数组
declare -A deals

# 使用普通数组中的元素作为关联数组的键
deals["${arr[0]}_data_cid"]="111"
deals["${arr[1]}_piece_cid"]="222"
deals["${arr[2]}_piece_size"]="red"

# 打印关联数组
for key in "${!deals[@]}"; do
    echo "$key -> ${deals[$key]}"
done
```

### 循环
```bash
# while 循环
while $condition
do
	$command
done

# 无限循环
while true
do
	$command
done

# for循环
sum=0
i=1
for ((;i<=100;i++));do
    ((sum += i))
done
echo "the sum is: $sum"

```
### 数组
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
# 遍历数组
for ipport in ${array_name[@]};do echo $ipport;done
for i in ${!array_name[@]};do echo ${array_name[i]};done
```

### 字符串的提取和替换
```bash
${var#*/} # 去掉变量var从左边算起的第一个'/'字符及其左边的内容
${var##*/} # 去掉变量var从左边算起的最后一个'/'字符及其左边的内容
${var%/*}
${var%/*}
for name in `ls *.Linux`;do mv $name ${name%.*};done
```

### 字符串分割
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
wait    # 会等待wait所在bash上的所有子进程执行结束
echo "5"
pid=$!  # 获取后台进程的 PID
wait $pid # 等待指定 PID 的进程完成

# 在 Bash 中，wait 支持 -n 选项结合超时控制，但需要 Bash 4.3 或更高版本。
sleep 5 &
sleep 10 &
wait -n 2s  # 等待任意任务完成或 2 秒超时
```

### timeout
```bash
# timeout 可能在某些系统（如 macOS）上不可用，需安装 coreutils 或使用手动方法。
#!/bin/bash
echo "Starting a task with timeout..."
timeout 3s sleep 5 &  # 设置 3 秒超时，但 sleep 5 秒
pid=$!
wait $pid
if [ $? -eq 124 ]; then
  echo "Task timed out!"
else
  echo "Task completed!"
fi
```

## 脚本
### 循环日期
```bash
#!/bin/bash
startDate=20210401
endDate=20230401
startSec=`date -d "$startDate" "+%s"`
endSec=`date -d "$endDate" "+%s"`
for((i=$startSec; i<=$endSec; i+=86400))
do
    firstday=`date -d "@$i" "+%Y%m%d"`
    echo ${firstday}
    # y=$[$i+86400]
    # secondday=`date -d "@$y" "+%Y%m%d"`
    # echo ${secondday}
done
```