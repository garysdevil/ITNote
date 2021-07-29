```golang
package main

import "fmt"

// 输入
func ScanFunc1(){
	var (
        name string
        age int
    )
    fmt.Scan(&name,&age)
    fmt.Println(name,age)
}

// 输入n行，然后输入n行数字
func ScanFunc2() {
	var n int
	var total = 0
	fmt.Scanln(&n)
	var slice []int = make([]int, n*2)

	
	for i := 0; i < n; i++ {
		fmt.Scan(&slice[i], &slice[i+1])
		total = total + slice[i] + slice[i+1]
	}
	fmt.Println(total)
}
// 输入的数字相加，直到输入0为止
func ScanFunc3() {
	var slice []int = make([]int, 100)
	var total,i int = 0,0
	for {
		fmt.Scan(&slice[i])
		if slice[i] == 0{
			break
		}
		total += slice[i]
		i += 1
	}
	fmt.Println(total)
}

// 输入num个字符串并且排序
func sortString() {
	var num int
	fmt.Scan(&num)
	var slice = make([]string, num)

	for i := 0; i < num; i++ {
		fmt.Scan(&slice[i])
	}
	sort.Strings(slice)
	str := strings.Join(slice, " ")
	fmt.Println(str)
}

```

