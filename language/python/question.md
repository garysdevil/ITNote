---
created_date: 2025-04-08
---

[TOC]

# 中级
## GIL

1. GIL（全局解释器锁）是 CPython 中的一个互斥锁，限制同一时刻只有一个线程执行 Python 字节码.
2. 目的：防止多线程竞争导致的内存管理问题。
3. 副作用：影响多线程性能，但不影响多进程。


## decorator
1. 是一种强大的语法特性，它允许在不修改原函数代码的情况下，动态增强函数的功能。
2. 示例：
    ```py
    def my_decorator(func):
        def wrapper():
            print("Before function")
            func()
            print("After function")
        return wrapper

    @my_decorator
    def say_hello():
        print("Hello!")

    say_hello()
    # 输出：
    # Before function
    # Hello!
    # After function
    ```
    
    ```py
    import time
    def timer(func):
        def wrapper(*args, **kwargs):
            start = time.time()
            result = func(*args, **kwargs)
            end = time.time()
            print(f"{func.__name__} 执行耗时: {end - start:.4f}s")
            return result
        return wrapper

    @timer # 等价于 heavy_calculation = timer(heavy_calculation)
    def heavy_calculation():
        time.sleep(2)

    heavy_calculation()  # 输出: heavy_calculation 执行耗时: 2.0002s
    ```

    ```py
    # 装饰器参数化，需嵌套三层函数
    def timer(unit="s"):  # 外层接收装饰器参数
        def decorator(func):  # 中层接收被装饰函数
            @wraps(func)
            def wrapper(*args, **kwargs):  # 内层处理逻辑
                start = time.time()
                result = func(*args, **kwargs)
                end = time.time()
                if unit == "ms":
                    print(f"耗时: {(end - start) * 1000:.2f}ms")
                else:
                    print(f"耗时: {end - start:.2f}s")
                return result
            return wrapper
        return decorator

    @timer(unit="ms")  # 使用参数化装饰器
    def quick_task():
        time.sleep(0.1)
    ```

## 单例
```
from threading import Lock

class ThreadSafeSingleton:
    _instance = None
    _lock = Lock()
    
    def __new__(cls):
        # 快速返回已存在的实例，避免不必要的锁竞争
        if cls._instance is not None:
            return cls._instance
            
        # 只有实例不存在时才获取锁
        with cls._lock:
            # 再次检查防止多个线程同时通过第一次检查
            if cls._instance is None:
                cls._instance = super().__new__(cls)
        return cls._instance
```

# 高级
## generator
1. 生成器（generator）是通过 yield 关键字实现的函数，逐个生成值而不是一次性返回所有值。
2. 优点： 节省内存，适合处理大数据。

## 多线程
1. 实现：使用 threading 模块实现多线程。
2. 劣势：由于 GIL 存在，CPU 密集型任务无法充分利用多核，适合 I/O 密集型任务。

## metaclass 不懂
