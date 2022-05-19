## Python求数学题
- C(n,m)
- C上标是m下标是n，表示从n个不同元素中任取m个元素的不同取法的种数，称为组合数。
- C上标是m下标是n，等于 (n!) / (m!*(n-m)!)
```python
math.factorial(n) / ( math.factorial(m) * math.factorial(n-m) )
```

- 使用python求阶乘
```python
import math
number=3
math.factorial(number)
```

- 使用python求根
```python
import cmath
cmath.sqrt(num)


# number的n次方根
numbe.0 ** (1 / n.0)
# 8的3次分根
8.0 ** (1 / 3.0)
```

```python
# 求概率
import math
total=7
hitTotal=1
hitProbability=0.1
combination=math.factorial(total)/(math.factorial(hitTotal)*math.factorial(total-hitTotal))
combination * pow(hitProbability,hitTotal) * pow((1-hitProbability),(total-hitTotal))
```