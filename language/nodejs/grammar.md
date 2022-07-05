# 语法
## 基本
```js
// 去掉所有空格
字符串.replace(/\s/g,"") 


// 函数声明方式一
function myFunction(p1, p2) {
  return p1 + p2;
};
// 函数声明方式二
const myFunction = async (p1, p2) => {
    return p1 + p2;
};

// 立即执行
(async () =>{
    await 函数名()
})()


// 返回触发事件的元素
event.target 
```


## 数据结构
### 数组
```js
let array = new Array()
array=[1 ,2 ,3]
array.push(4) // 元素添加到尾部
array.unshift(5) // 元素添加到头部
array.shift() // 删除并返回头部元素
array.pop() // 删除并返回尾部元素
array.indexOf('') // 返回指定内容元素的下标，不存在则返回-1
array。splice(index,索引) // 通过索引删除元素并返回此元素
```

### 字典
```js
new Map()
set()
get()
delete()
```

## 常用函数
- forEach(),filter(), map(),reduce()
```js
    array = ['a','b']
    array.forEach((value, key )=>{
        console.log(value)
    })
```

## 回调地狱
- 将回调函数处理成像“同步”处理的形式
promise， async await

## 异常处理
```js
try {	
  console.log('我正在执行');	
  // throw new Error('错误信息');	
} catch (e) {	
  console.error(e.message);	
  console.log('异常被捕获了，我现在还可以继续执行了');
}
```


## 休眠
```js
function sleep(ms) {
    return new Promise(resolve => setTimeout(() => resolve(), ms));
};
(async () =>{
  console.log(1)
  await wait(2000);
  console.log(2)
})()
```