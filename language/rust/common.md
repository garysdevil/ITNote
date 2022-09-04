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


let v1 = vec![1, 2, 3, 4];
let b1 = v1.into_boxed_slice(); // 从 Vec<T> 转换成 Box<[T]>，此时会丢弃多余的 capacity
let v2 = b1.into_vec(); // 从 Box<[T]> 转换成 Vec<T>
```