
### 数据类型
0. 基本类型
1. 变量的声明与赋值。
    - var f string = "Runoob" 简写为 f := "Runoob"
    - :=  一种动态声明方式，出现在 := 左侧的变量不能是已经被声明过的，否则会导致编译错误，此方式只能在函数体中出现。
2. 常量 
   const identifier [type] = value

2. 数组
声明：var variable_name [SIZE] variable_type
声明与初始化：var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}

3. 切片：动态数组
声明与初始化切片：var identifier []type = make([]T, length, capacity)
len() 获取长度
cap() 获取最长可达
当追加值时，容量不够，则容量进行翻倍。

4. Map集合
```go
/* 声明变量，默认 map = nil */
var map_variable map[key_data_type]value_data_type
/* 使用 make 函数 */
map_variable := make(map[key_data_type]value_data_type)
例如
ab := map[string]string{"a":"a1","b":"b1"}
ab["c"] = "c1"

根据键删除某个值 delete(map_variable,key)

5. 结构体
```go
type struct_variable_type struct {
   member definition;
   ...
   member definition;
}
```

6. 接口
```go
type interface_name interface {
   method_name1 [return_type]
   ...
   method_namen [return_type]
}
/* 实现接口方法 */
func (struct_name_variable struct_name) method_name1() [return_type] {
   /* 方法实现 */
}
```

7. 通道（channel）是用来传递数据的一个数据结构。
   1. 可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。
   2. 操作符 <- 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

   3. 创建通道： ```ch := make(chan int)``` 

   4. 创建通道并设置缓冲区：```ch := make(chan int, 100)```

### 语法规则
1. 在函数内，变量声明而不使用，编译时则会报错。

2. 结构体变量名：大写表示外部可以访问。

3. 关于函数的大括号
```go
func main()  
{  // 错误，{ 不能在单独的行上
    fmt.Println("Hello, World!")
}
```
4. 函数可以直接返回多个值
```go
func swap(x, y string) (string, string) {
   return y, x
}
```

5. 循环 只有for循坏：break，continue，goto
    - for 循环不需要()
    - for k, v := range kvs 循环数组、切片、map，返回元素的索引和索引对应的值。 

6. Go 并发，通过go关键字开启一个 goroutine 协程
```go
go function_name ( parameter_value )
```

7. 支持类型转换
float32(parameter_name)

### CLI操作
1. 编译当前目录并输出指定可执行文件
go build -o 输出指定文件

2. 编译运行
go run .















