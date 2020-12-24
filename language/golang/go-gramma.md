
### 数据类型
0. 基本类型
1. 变量的声明与赋值。
   ```go
   var identifier string = "gary" 
   // 函数内可简写为 
   identifier := "gary"
   // identifier := value  一种动态声明方式，左侧的变量不能是已经被声明过的，否则会导致编译错误，此方式只能在函数体中出现。
   ```

2. 常量 
   ```go
      // 常量的值必须是编译运行前确定的
      const identifier [type] = value
   ```
3. 数组
   ```go
   // 声明
   var variable_name [SIZE] variable_type
   // 声明与初始化
   var balance = [5]float32{10.0, 50.0}
   ```
3. 切片：动态数组
```go
// 声明与初始化切片
var identifier []type = make([]type, length, capacity)
// 获取长度
len() 
// 获取最长可达
cap()
// 追加值，当容量不够时，则容量进行翻倍。
append(切片, 元素)
```
4. Map集合
```go
/* 声明变量，默认 map = nil */
var map_variable map[key_data_type]value_data_type
/* 使用 make 函数初始化变量 */
map_variable := make(map[key_data_type]value_data_type)

// 例如
ab := map[string]string{"a":"a1","b":"b1"}
ab["c"] = "c1"

// 根据键删除某个值 
delete(map_variable,key)
```

5. 结构体
```go
// 定义结构体
type Struct_variable_type struct {
   Member definition;
   ...
   Member definition;
}
// 实现结构体的4种方式
structName := new(Struct_variable_type)
structName := &Struct_variable_type{}
structName := &struct_variable_type{value1, value2}
structName := &struct_variable_type{
   key1 : value1,
   key2 : value2,
}
```

6. 接口
```go
type interface_name interface {
   method_name1 [return_type]
   ...
   method_namen [return_type]
}
// 结构体实现接口
func (struct_name_variable struct_name) method_name() [return_type] {
   /* 具体的方法 */
}
```

7. 通道（channel）是用来传递数据的一个数据结构。
   1. 可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。
   2. 操作符 <- 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

   3. 通道的创建 
   ```go
   // 创建通一个int类型的通道
   ch := make(chan int) 
   // 创建int类型的通道并设置缓冲区
   ch := make(chan int, 100)
   ``` 

### 特有语法
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
    - for i := 0; i < 10; i++{}
    - for k, v := range kvs{} 循环数组、切片、map，返回元素的索引和索引对应的值。 

6. Go 并发，通过go关键字开启一个 goroutine 协程
   ```go
   go function_name ( parameter parameter_type ){}
   ```

7. 支持类型转换
float32(parameter_name)
















