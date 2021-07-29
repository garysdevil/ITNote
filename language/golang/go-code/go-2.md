```golang
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
// 冒泡排序
func bubbleSort(slice []int) {
	length := len(slice)
	flag := true
	for i := 0; i < length-1; i++ {
		for j := 0; j < length-1-i; j++ {
			if slice[j] > slice[j+1] {
				slice[j], slice[j+1] = slice[j+1], slice[j]
				flag = false
			}
		}
		if flag {
			return 
		}
	}
}
// 二分查找
func dichotomy(slice []int, value int) int {
	start, end, mid := 0, len(slice)-1, 0
	for {
		mid = (start + end) / 2
		// fmt.Println(start, end, mid)
		if value > slice[mid] {
			start = mid + 1
		} else if value < slice[mid] {
			end = mid - 1
		} else {
			// fmt.Println(mid)
			// break
			return mid
		}
		if start > end {
			// fmt.Println("There are not target in slice")
			// break
			return -1
		}
	}
}

```