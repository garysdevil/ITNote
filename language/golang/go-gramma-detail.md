### type关键字的几种使用方式
- type关键之用来定义类型

1. 定义结构体类型
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

3. 定义接口类型
```go
type Phone interface {
   call()
}
```

4. 定义函数类型
```go
type handle func(str string)  //自定义一个函数func，别名叫做handle，传入一个string参数
```

### switch
```go
func main() {
	/* 定义局部变量 */
    var grade string = "Z"
	var marks int = 80
 
	switch marks {
	   case 90: grade = "A";
	   case 80: 
	   		grade = "B";
	   		fallthrough; // 强制执行下一条case
	   case 50,60,70 : 
			grade = "C";
			fmt.Printf("test\n");  
	   default: grade = "D";
	}
	fmt.Printf("你的等级是 %s\n", grade );    
 }
```

### for
```go
func main() {
	/* 定义局部变量 */
	var a int = 10

	/* 循环 */
	for a < 20 {
		if a == 15 {
			/* 跳过迭代 */
			a = a + 1
			goto LOOP
		}
		fmt.Printf("a的值为 : %d\n", a)
		a++
    }
	LOOP:
		fmt.Println("----")

}
```