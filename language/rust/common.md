---
created_date: 2022-09-05
---

[TOC]

```rs
// 一个字节向量 Vec<u8> 转换为String
fn main1() {
    let bytes = vec![0x41, 0x42, 0x43];
    let s = String::from_utf8(bytes).expect("Found invalid UTF-8");
    println!("{}", s);
}
// 一个字节向量 [u8 ]转换为String
fn main2() {
    let buf = &[0x41u8, 0x41u8, 0x42u8];
    let s = String::from_utf8_lossy(buf); // from_utf8_lossy将无效的UTF-8字节转换为 ，因此不需要进行错误处理。
    println!("result: {}", s);
}

// Vec<T> 和 Box<[T]> 互转
fn main3(){
    let v1 = vec![1, 2, 3, 4];
    let b1 = v1.into_boxed_slice(); // 从 Vec<T> 转换成 Box<[T]>，此时会丢弃多余的 capacity
    let v2 = b1.into_vec(); // 从 Box<[T]> 转换成 Vec<T>
}
```


```rs
// 迭代器迭代
fn main(){
    let vec = vec!["a".to_owned(), "b".to_owned(), "c".to_owned(), "d".to_owned(), "f".to_owned()];
    let iter = vec.iter();
    let mut iter1 = iter.clone();
    let mut iter2 = iter.clone();
    let mut iter3 = iter.clone();

    println!("for iter"); // 迭代失败
    for element in &iter1.next() {
        println!("{:?}",element);
    }

    println!("loop iter");
    loop {
        match &iter2.next() {
            None => break,
            Some(element) => {
                println!("{:?}", element);
            }
        }
    }
    
    println!("while iter");
    while let Some(element) = &iter3.next() {
        println!("{:?}", element);
    }
}
```