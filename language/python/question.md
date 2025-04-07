## 中级
1. 什么是装饰器（decorator）？如何实现一个简单的装饰器？
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