
## 数据类型
### 声明与赋值
- 变量的声明与赋值。
   ```go
   var var_name string = "gary" 
   var var_name1,var_name2 string = "gary1","gary2"
   // 多个不同类型变量的声明
   var (
      var_name2 string
      var_name2 int
   )
   // 函数内可简写为。
   func test(){
      var_name := "gary" // 一种动态声明方式，左侧的变量不能是已经被声明过的，否则会导致编译错误，此方式只能在函数体中出现。
   }
   ```
### 基本类型
1. 基本类型
   - 布尔型、数字类型、字符串类型、数组

2. 数组
   ```go
   // 声明
   var var_arr_name1 [var_size] var_type
   // 声明与初始化
   var var_arr_name2 = [5]float32{10.0, 50.0}
   ```

3. 常量 
   ```go
   // 常量的值必须是编译运行前确定的
   // 常量中的数据类型只可以是布尔型、数字型（整数型、浮点型和复数）和字符串型
   // const var_name var_type = value
   const name string = "gary"

   // 枚举
   type ValueType int32
   const (
      Value_MIN      ValueType = 0
      Value_MAX      ValueType = 10
      Value_MID      ValueType = 6
      Value_AVG      ValueType = 5
   )
   ```

### 引用类型
- 引用类型
   - 切片、字典(map)、通道（channel）、接口（interface）

- 指针类型
   ```go
	num1_var := 255
	var num2_var *int = &num1_var
	fmt.Printf("Type of num2_var is %T\n", num2_var)
	fmt.Println("Address of num2_var is", num2_var)
   ```
   
1. 切片：动态数组
   ```go
   // 声明与初始化切片
   var var_slice_name []var_type = make([]var_type, var_length, var_capacity)
   var_slice_name := []string{"a1","a2","a3"}
   // 获取长度
   len(var_slice_name) 
   // 获取最长可达
   cap(var_slice_name)
   // 追加值，当容量不够时，则容量进行翻倍。
   append(var_slice_name, 元素)
   ```

2. 无序集合map
   ```go
   /* 声明变量，默认 map = nil */
   var var_map_name map[key_type]value_type
   /* 使用 make 函数初始化变量 */
   var_map_name := make(map[key_type]value_type)

   // 例如
   vks := map[string]string{"a":"a1","b":"b1"}
   vks["c"] = "c1"

   // 根据键删除某个值 
   delete(map_variable,key)
   ```

### type关键字

1. 结构体 struct
   ```go
   // 定义结构体
   type Struct_var_type struct {
      var_name1 int;
      var_name2 string;
      // ...
   }
   // 初始化结构体的4种方式
   struct_var_name := new(Struct_var_type)
   struct_var_name  := &Struct_var_type{}
   struct_var_name  := &struct_var_type{value1, value2}
   struct_var_name  := &struct_var_type{
      key1 : value1,
      key2 : value2,
   }
   ```

2. 接口 interface
   ```go
   type interface_name interface {
      method_name1(slice []string) string
      method_name2()
      // ...
   }

   // 结构体实现接口
   func (struct_name_variable struct_name) method_name() 返回的数据类型 {
      /* 具体的方法 */
   }
   ```

3. 函数类型
   - 声明
   ```go
   type func_name func(name string) string
   ```
   - 示范
   ```go
   //定义函数类型 Doing
   type Doing func(thing string) string

   func eating(food string) string {
      return "我正在吃" + food
   }
   func drinking(drink string) string {
      return "我正在喝" + drink
   }

   //形参指定传入参数为函数类型Doing
   func Action(doing Doing, thing string) string {
      return doing(thing)
   }
   func main() {
      result := Action(eating, "苹果")
      fmt.Println(result)
   }
   ```
4. 根据已有数据类型，定义新类型
   ```go
   type typename string
   func (n typename) len() int {
      return len(n)
   }
   ```
### 通道
1. 通道 channel
   - 传递数据的一钟数据结构。
   - 可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。
   - 操作符 <- 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

   - 通道的创建
   ```go
   // 创建通一个int类型的通道
   ch := make(chan int) 
   // 创建int类型的通道并设置缓冲区
   ch := make(chan int, 100)
   ``` 

## 语法特性
### 基本特性
1. 在函数内，变量声明而不使用，编译时则会报错。

2. 结构体变量名：大写表示外部可以访问。

3. 支持类型转换
   ```go
   var1_name := 22
   var2_name := float32(var1_name)
   fmt.Printf("Type of var2_name is %T\n", var2_name)
   ```
### 函数
1. 关于函数的大括号
```go
func main()  
{  // 错误，{ 不能在单独的行上
    fmt.Println("Hello, World!")
}
```

2. 函数可以直接返回多个值
```go
func swap(x, y string) (string, string) {
   return y, x
}
```

3. 匿名函数
```go
func(){
    fmt.Println("hello")
}
```
### 接口
- 在golang里，接口内函数的实现不需要关键字，是被隐式实现的
```go
   type Mammal interface {
      Say()
   }
   type Dog struct{}
   func (d Dog) Say() {
      fmt.Println("woof")
   }
   func main() {
      var m Mammal
      m = Dog{}
      m.Say()
   }
```

### 循环
1. 循环 只有for循坏：break，continue，goto

2. for 循环不需要()
   ```go
   for i := 0; i < 10; i++{} 
   ```

3. 循环数组、切片、map，返回元素的索引和索引对应的值。
```go
for k, v := range kvs{
   if v == 1 {continue} // 跳过当前循环的剩余语句，然后继续进行下一轮循环
   goto MyBreak // 将控制转移到被标记的语句
} 
MyBreak: fmt.Println("my break")
```

### 条件语句
1. if
```go
func judge(num int) int {
    if num > 100 {
        return 100
    }else if num < 0 {
        return 0
    }else{
        return -1
    }
}
``` 
2. switch 
```go
func main() {
   // 使用方式一
   var x interface{}    
   switch i := x.(type) {
      case nil:  
         fmt.Printf(" x 的类型 :%T",i)                
      case int:  
         fmt.Printf("x 是 int 型")                      
      case float64:
         fmt.Printf("x 是 float64 型")          
      case func(int) float64:
         fmt.Printf("x 是 func(int) 型")                      
      case bool, string:
         fmt.Printf("x 是 bool 或 string 型" )      
      default:
         fmt.Printf("未知型")    
   }
   // 使用方式二
   grade := "C"
   switch {
      case grade == "A" :
         fmt.Printf("优秀!\n" )    
      case grade == "B", grade == "C" :
         fmt.Printf("良好\n" )
         fallthrough // 设置不判断下一条case表达式而直接执行下一条case里面的语句
      default:
         fmt.Printf("差\n" );
   }
}
```

### 并发
1. Go 并发，通过go关键字开启一个 goroutine 协程
   ```go
   go function_name ( var_value )
   ```

