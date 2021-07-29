package main

import "fmt"

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


// 求n次方 math.Pow(num,power)
func exponent(num,power int)int{
    var result int
    if num==0{
        return 0
    }
    if power==0{
        return 1
    }
    for i:=0; i<power-1; i++{
        result = num*num
    }
    return result
}

