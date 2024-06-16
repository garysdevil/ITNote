## AI
- 订阅chatgpt4
    1. 购买苹果美区礼品卡 
        - 方式一 在苹果官网购买 https://www.apple.com/shop/buy-giftcard/giftcard 
        - 方式二 在支付宝，选择美国地区，购买Apple礼品卡
        - 方式三 App Store 直接充值
    2. App Store 美国账号余额
        1. 兑换礼品卡为余额
        2. 直接充值(需要美国信用卡或paypal)
    3. 下载chatgpt软件，订阅chatgpt4

1. 视频自动生成 
    1. https://www.capcut.com/
    2. https://app.fliki.ai/

2. 查重
    1. uoonn.com
    2. https://originality.ai/
    3. https://gptzero.me/  检测技术差

# Prompt 
- 参考 https://learningprompt.wiki/docs/chatgpt-learning-path
## 场景
1. 简单问答模式。精确、具体。
2. 根据例子回答问题。
```
Suggest three names for a horse that is a superhero.

Animal: Cat
Names: Captain Sharpclaw, Agent Fluffball, The Incredible Feline
Animal: Dog
Names: Ruff the Protector, Wonder Canine, Sir Barks-a-Lot
```
3. 推理/推断。
4. 写代码。
5. 文本转换
6. 解释。
7. 信息总结。
8. 信息提取。

## 高级技巧
### Prompts 框架
1. Basic Prompt Framework
    1. Instruction（required）： The specific task you want the model to perform.
    2. Context（optional）： Background information providing context to guide better responses.
    3. Input Data (optional): Data for the model to process.
    4. Output Indicator (optional): Specifies desired output type or format.
2. CRISPE Prompt Framework
    1. CR： Capacity and Role - The role for ChatGPT to take on.
    2. I： Insight - Background info and context (I think Context is clearer).
    3. S： Statement - What you want ChatGPT to do.
    4. P： Personality - Desired style or manner for responses.
    5. E： Experiment - Ask for multiple answers.

### Zero-Shot Prompts 零样本提示
- Zero-Shot Chain of Thought
### Few-Shot Prompting 少量样本提示



## 实践
```md
- 角色: 我是一位精通区块链和nodejs代码的软件工程师
- 需求:
- 完成需求方式: 通过Node.js代码实现，给出一个完整可运行的例子
- Node.js代码规格:
    1. Node.js版本 v18.19.0
    2. 将代码写进一个函数内，通过主函数进行调用
    3. 下载依赖时指定版本号，尽量使用最新的版本依赖
    4. 函数有注释
    5. 代码书写规则符合eslint-config-airbnb-base格式
    6. 使用ESM模块系统
```

```md
- 你是一位区块链研究专家。
- 对于一个区块链项目，针对以下几点进行研究输出，最后输出markdown格式的文档
    1. 项目的Discord、Twitter、Telegram、Github、白皮书、官网、文档链接
    2. 项目简介，以及解决了什么问题
    3. 项目的团队背景
    4. 项目的融资（每轮融资的时间点和金额）
    5. 项目的经济模型
    6. 项目的技术原理
    7. 项目的共识激励机制
    8. 项目的路线图和事件
    9. 项目的同类项目对比
    10. 项目前景分析
- 针对XX项目进行研究输出



```