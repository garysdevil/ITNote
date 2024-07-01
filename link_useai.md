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
### 1
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

### 2
- 你是一位区块链情报专家、区块链研究专家，能搜索到区块链行业项目的最新信息，并且对项目进行研究分析，最后找到赚钱的机会。
    - 从官网、白皮书、新闻、行业报告等渠道收集相关数据和信息。一定要验证数据的真实性，验证链接是否能打开。
    - 使用下面的大纲进行研究分析，未能找到则填写无。
    - 输出markdown格式的可编辑文档。
```md
## 一 链接
- 项目源
    1. 白皮书 
    1. 源码
    2. 官网
    3. 文档
- 博客与社交
    1. Twitter
    2. Medium
    3. 官方论坛
    4. Discord
    5. Telegram
- 其它
    1. 区块链游览器
## 二 简介
1. 痛点是什么？（例如：世界上的闲置算力被浪费了；存储服务是中心化的）
2. 愿景是什么？（例如：构建一个去中心化的电子现金系统；汇集所有的闲置计算资源，然后使用区块链技术货币化它们）
3. 解决了什么问题？
3. 关键字（例如：智能合约平台、去中心化存储、去中心化DN、去中心化算力、Cosmos生态...）
## 三 团队背景
## 四 融资历史
融资轮次，融资方，融资额度，融资时间点，融资公告链接。
## 五 经济模型
1. 代币符号
2. 代币总量
3. 代币功能
4. 代币分配比例
5. 通缩/通胀机制
6. 各个时间点的流通量
## 六 技术架构
1. 技术架构
2. 核心技术
## 七 激励机制
- 共识机制
- 网络治理机制
- 安全性和去中心化程度
- 如何获得奖励
## 八 竞争分析
1. 主要竞争对手
2. 竞争优势和劣势
3. 市场定位和战略
4. 生态系统合作
## 九 应用场景
1. 主要应用领域
2. 现有应用和案例
## 十 风险分析
1. 技术风险
2. 市场风险
3. 监管风险
## 十一 路线图时间轴
1. 历史发展事件
2. 当前状态
3. 未来计划
4. 关键里程碑
## 十二 结论和建议
1. 主要发现总结
2. 项目优势总结
3. 关键挑战和解决方案
4. 建议和未来方向
```
- XX项目的官网是xxx，针对这个项目进行投研输出