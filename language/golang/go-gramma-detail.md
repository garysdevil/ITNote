### type的几种使用方式
1. 定义结构体
```go
type person struct {
    // name string //注意后面不能有逗号
    age  int
}
```

2. 根据已有类型，定义新类型
```go
type typename string
func (n typename) len() int {
    return len(n)
}
```

3. 定义接口
```go
type Phone interface {
   call()
}
```

4. 定义函数类型
```go
type handle func(str string)  //自定义一个函数func，别名叫做handle，传入一个string参数
···
