- 参考 https://github.com/zhaotoday/fingerprint-browser

## 浏览器自动化
- 自动化浏览器的两个主要协议
    - WebDriver
    - Chrome DevTools Protocol（CDP）

| 特性         | WebDriver                      | Chrome DevTools Protocol (CDP)      |
| :----------- | :----------------------------- | :---------------------------------- |
| **标准化**   | W3C 标准，跨浏览器支持         | Chrome 专属，基于 Chromium 的浏览器 |
| **通信协议** | HTTP                           | WebSocket                           |
| **功能范围** | 高级浏览器操作（点击、导航等） | 底层控制（DOM、网络、性能等）       |
| **易用性**   | 简单易用，适合初学者           | 需要更多技术背景，适合高级用户      |
| **性能**     | 较慢（基于 HTTP 请求）         | 更快（基于 WebSocket 实时通信）     |
| **使用场景** | 自动化测试、网页抓取           | 高级抓取、性能分析、调试            |
| **工具支持** | Selenium、Playwright           | Puppeteer、PyCDP、Playwright        |


## 无头浏览器
- 无头浏览器（Headless Browser） 
    1. 没有图形用户界面（GUI） 的浏览器，它可以在 后台运行，并且仍然能够加载网页、执行 JavaScript 代码、与页面进行交互，就像普通浏览器一样。
    2. 是 一个“看不见”的浏览器，可以在 命令行 或 代码 中控制它，而无需打开窗口。
    3. Puppeteer 和 Playwright 是目前最流行的无头浏览器工具，功能强大且易于使用。

1. Puppeteer (基于 Chromium) 
    1. https://pptr.dev
    2. 是 Google 开发的 Node.js 库，提供对无头 Chrome 或 Chromium 的高级控制。
2. Playwright (多浏览器支持)
    1. https://playwright.dev
    2. 是微软开发的一个自动化测试工具，支持 Chromium、Firefox 和 WebKit 的无头模式。
3. Selenium (多浏览器支持)
    1. https://www.selenium.dev
    2. 是一个广泛使用的自动化测试框架，支持无头模式运行 Chrome、Firefox 等浏览器。
4. Headless Chrome
    1. Chrome 浏览器本身支持无头模式，可以通过命令行或脚本启动。 `chrome --headless --disable-gpu --remote-debugging-port=9222`
5. Headless Firefox
    1. Firefox 也支持无头模式，适合在无界面环境中运行。 `firefox --headless`
6. Splash (基于 WebKit)
    1. https://splash.readthedocs.io
    2. 是一个基于 WebKit 的无头浏览器，主要用于网页抓取和 JavaScript 渲染。
7. HtmlUnit (Java 无头浏览器)
    1. http://htmlunit.sourceforge.net
    2. 是一个基于 Java 的无头浏览器，主要用于测试和网页抓取。
8. Zombie.js (Node.js 无头浏览器)
    1. http://zombie.js.org
    2. 是一个轻量级的 Node.js 无头浏览器，适合快速测试和抓取。

## 浏览器指纹
- 浏览器指纹
    - Canvas指纹
    - WebGL指纹
    - AudioContext指纹
    - UserAgent指纹
    - 语言偏好指纹
    - 字体指纹： 游览器可以通过特定的JS脚本列出用户设备上的所有字体。
    - 分辨率指纹
    - Client Rects指纹
    - Speech Voice指纹
    - 线程数和内存指纹

- 浏览器指纹检测
    1. https://fingerprintjs.github.io/fingerprintjs/  对应源码 https://github.com/fingerprintjs/fingerprintjs
    2. https://browserleaks.com/



## LavaMoat
- https://github.com/LavaMoat/LavaMoat

1. LavaMoat：一个沙箱工具，通过隔离依赖和限制权限保护应用。
    1. 为项目中的每个依赖包创建一个独立的“沙箱环境”（称为 compartment），限制它们能访问的 API 和全局对象。
    2. 通过静态分析依赖树的模块，LavaMoat 生成配置，明确每个包可以访问哪些资源。

2. Scuttling Mode：LavaMoat 的增强功能，破坏全局对象（如 globalThis），防止恶意代码滥用。


- LavaMoat 机制触发的错误
    ```log
    unknown error: Runtime.callFunctionOn threw exception: Error: LavaMoat - property "open" of globalThis is inaccessible under scuttling mode.
    ```

- Scuttling Mode 机制触发的错误
    ```log
    Error: LavaMoat - property "Proxy" of globalThis is inaccessible under scuttling mode.
    To learn more visit https://github.com/LavaMoat/LavaMoat/pull/360
    ```