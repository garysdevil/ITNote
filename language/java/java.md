# Java
## 安装openjdk
1. CentOS7源安装
    yum install java-1.8.0-openjdk* -y

    yum insatll java的默认路径（默认只装jar）
    yum install java-devel（包含javac）

2. Ubuntu16源安装
apt-get update -y
apt-get install openjdk-8-jdk -y

- java -version
- java目录 /usr/lib/jvm/

3. 手动环境变量配置
vi /etc/profile.d/java.sh
```conf
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.265.b01-0.54.amzn1.x86_64  # 名字会不一样
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/jre/lib/rt.jar
export PATH=$PATH:$JAVA_HOME/bin
```


4. 设置新的软连接
/usr/bin/java -> /etc/alternatives/java
/etc/alternatives/java -> /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java

ln -fs /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java /etc/alternatives/java

5. 卸载
    - 若是oracle-jdk 
        apt-get remove oracle-java8-installer
    - 若是openjdk
        apt-get remove/purge openjdk* 
        
## JVM

### 指令
- 参考 https://www.jdon.com/51214
```bash
# 0. 查看当前用户的Java进程信息
jps -mlv 

# 1. 查看进程JVM当前运行的配置信息
jinfo -flags ${PID} 

# 2. 查看进程JVM最大堆内存大小
jinfo -flag MaxHeapSize ${PID}

# jstat(Java Virtual Machine statistics monitoring tool)：查看堆内存各部分的使用量，以及加载类的数量
# 堆内存统计
jstat -gccapacity ${PID}
# gc统计
jstat -gcutil ${PID}
```



### 配置jvm的堆内存占据宿主机内存的百分比
- 基于 Java 8u131 或 Java 9
    - java XX:InitialRAMFraction=1 -XX:MaxRAMFraction=1 -XX:MinRAMFraction=1  -jar test.jar
- 基于 Java 10
    - 这三个参数是JDK8U191为适配Docker容器新增的
    - java MaxRAMPercentage=1 InitialRAMPercentage=1 MinRAMPercentage=1 -jar test.jar

### 常用 JVM 参数
- -Xms：初始堆大小，默认为物理内存的1/64(<1GB)；
    - 默认(MinHeapFreeRatio参数可以调整)空余堆内存小于40%时，JVM就会增大堆直到-Xmx的最大限制

- -Xmx：最大堆大小，默认为物理内存的1/4；
    - 默认(MaxHeapFreeRatio参数可以调整)空余堆内存大于70%时，JVM会减少堆直到 -Xms的最小限制

- -Xmn：新生代的内存空间大小，注意：此处的大小是（eden+ 2 survivor space)。与jmap -heap中显示的New gen是不同的。
    - 整个堆大小 = 新生代大小 + 老生代大小 + 永久代大小。在保证堆大小不变的情况下，增大新生代后,将会减小老生代大小。此值对系统性能影响较大,Sun官方推荐配置为整个堆的3/8。

- -XX:SurvivorRatio：新生代中Eden区域与Survivor区域的容量比值，默认值为8。两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10。

- -Xss：每个线程的堆栈大小。JDK1.5.0以后每个线程堆栈大小为1M,以前每个线程堆栈大小为256K。应根据应用的线程所需内存大小进行适当调整。在相同物理内存下,减小这个值能生成更多的线程。但是操作系统对一个进程内的线程数还是有限制的，不能无限生成，经验值在3000~5000左右。一般小的应用， 如果栈不是很深， 应该是128k够用的，大的应用建议使用256k。这个选项对性能影响比较大，需要严格的测试。和threadstacksize选项解释很类似,官方文档似乎没有解释,在论坛中有这样一句话:"-Xss is translated in a VM flag named ThreadStackSize”一般设置这个值就可以了。

- -XX:PermSize：设置永久代(perm gen)初始值。默认值为物理内存的1/64。

- -XX:MaxPermSize：设置永久代最大值。物理内存的1/4。

### GC
- Java的堆内存逻辑上分成两块：新生代、老年代
- 根据垃圾收集回收的区域不同可分为： Young GC、Old GC、Full GC、Mixed GC
- 大多数情况下，对象在先新生代Eden区中分配。当Eden区没有足够空间进行分配时，虚拟机将发起一次Young GC。
- -XX:PretenureSizeThreshold
- -XX:MaxTenuringThreshold
- 