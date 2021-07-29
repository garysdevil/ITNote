
## 数据类型
0. 变量的声明与赋值。
   ```go
   var var_name string = "gary" 
   var var_name1,var_name2 string = "gary1","gary2"
   // 多个不同类型变量的声明
   var (
      var_name2 string
      var_name2 int
   )
   // 函数内可简写为。
   var_name := "gary" // 一种动态声明方式，左侧的变量不能是已经被声明过的，否则会导致编译错误，此方式只能在函数体中出现。
   ```

1. 基本类型
   - 布尔型、数字类型、字符串类型

2. 常量 
   ```go
      // 常量的值必须是编译运行前确定的
      // const var_name var_type = value
      const name string = "gary"
   ```

3. 数组
   ```go
   // 声明
   var var_arr_name1 [var_size] var_type
   // 声明与初始化
   var var_arr_name2 = [5]float32{10.0, 50.0}
   ```

4. 切片：动态数组
   ```go
   // 声明与初始化切片
   var var_slice_name []type = make([]var_type, var_length, var_capacity)
   // 获取长度
   len() 
   // 获取最长可达
   cap()
   // 追加值，当容量不够时，则容量进行翻倍。
   append(切片, 元素)
   ```

5. 无序集合map
   ```go
   /* 声明变量，默认 map = nil */
   var var_map_name map[key_data_type]value_data_type
   /* 使用 make 函数初始化变量 */
   var_map_name := make(map[key_data_type]value_data_type)

   // 例如
   vks := map[string]string{"a":"a1","b":"b1"}
   vks["c"] = "c1"

   // 根据键删除某个值 
   delete(map_variable,key)
   ```

6. 结构体 struct
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

7. 接口 interface
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

7. 通道 channel
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

8. 函数类型 *todu 等待深入*
   ```go
   type func_name func(name string) string
   ```

9. 指针类型
   ```go
   var a *int
   ```

10. 引用类型
数组切片、字典(map)、通道（channel）、接口（interface）

## 特有语法
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
   - continue 跳过当前循环的剩余语句，然后继续进行下一轮循环
   - goto 将控制转移到被标记的语句

6. Go 并发，通过go关键字开启一个 goroutine 协程
   ```go
   go function_name ( parameter parameter_type ){}
   ```

7. 支持类型转换
float32(parameter_name)


## 常规语法
1. switch 

2. 











