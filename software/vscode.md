---
created_date: 2020-11-16
---

[TOC]

# vscode
- 参考文档  
    - https://geek-docs.com/vscode/vscode-tutorials/what-is-vscode.html
    - https://segmentfault.com/a/1190000037516796
    - https://www.cnblogs.com/bindong/p/6045957.html

## 快捷键 
- 在Mac系统内，快捷键的Ctrl按键往往被替换为Cmd按键

### 自定义快捷键
- 打开
    - Ctrl + Shift + P 
    - Preferences: Open Keyboard shortcurs(JSON)
```json
// 新终端和切换终端的快捷键
    { "key": "cmd+1",                "command": "workbench.action.terminal.focusAtIndex1", "when": "terminalFocus" },
    { "key": "cmd+2",                "command": "workbench.action.terminal.focusAtIndex2", "when": "terminalFocus" },
    { "key": "cmd+3",                "command": "workbench.action.terminal.focusAtIndex3", "when": "terminalFocus" },
    { "key": "cmd+4",                "command": "workbench.action.terminal.focusAtIndex4", "when": "terminalFocus" },
    { "key": "cmd+5",                "command": "workbench.action.terminal.focusAtIndex5", "when": "terminalFocus" },
    { "key": "cmd+6",                "command": "workbench.action.terminal.focusAtIndex6", "when": "terminalFocus" },
    { "key": "cmd+7",                "command": "workbench.action.terminal.focusAtIndex7", "when": "terminalFocus" },
    { "key": "cmd+8",                "command": "workbench.action.terminal.focusAtIndex8", "when": "terminalFocus" },
    { "key": "cmd+9",                "command": "workbench.action.terminal.focusAtIndex9", "when": "terminalFocus" },
    { "key": "cmd+m",                "command": "workbench.action.toggleMaximizedPanel", "when": "terminalFocus"},
    { "key": "cmd+t",                "command": "workbench.action.terminal.new", "when": "terminalFocus" },
    { "key": "cmd+w",                "command": "workbench.action.terminal.kill",  "when": "terminalFocus"},

// 页面切换
[
    { "key": "cmd+1",                "command": "workbench.action.openEditorAtIndex1", "when": "editorTextFocus" },
    { "key": "cmd+2",                "command": "workbench.action.openEditorAtIndex2", "when": "editorTextFocus" },
    { "key": "cmd+3",                "command": "workbench.action.openEditorAtIndex3", "when": "editorTextFocus" },
    { "key": "cmd+4",                "command": "workbench.action.openEditorAtIndex4", "when": "editorTextFocus" },
    { "key": "cmd+5",                "command": "workbench.action.openEditorAtIndex5", "when": "editorTextFocus" },
    { "key": "cmd+6",                "command": "workbench.action.openEditorAtIndex6", "when": "editorTextFocus" },
    { "key": "cmd+7",                "command": "workbench.action.openEditorAtIndex7", "when": "editorTextFocus" },
    { "key": "cmd+8",                "command": "workbench.action.openEditorAtIndex8", "when": "editorTextFocus" },
    { "key": "cmd+9",                "command": "workbench.action.openEditorAtIndex9", "when": "editorTextFocus" },
]
```

### 工作区快捷键
1. 显示命令面板：VS Code 的绝大多数命令都可以在命令面板里搜到   
    - F1 或者 “Ctrl + Shift + P”

2. 折叠和展开
    1. 折叠所有区域代码的快捷键
        - 先按下  Ctrl + K，再按下 Ctrl 和 0
    2. 展开所有折叠区域代码的快捷键
        - 先按下  Ctrl 和 K，再按下 Ctrl 和 J

3. 显示/隐藏侧边栏
    - Ctrl + B

4. 聚焦到第 1、第 2 个编辑器
    - Ctrl + 1
    - Ctrl + 2

5. 将工作区放大/缩小
    - Ctrl +
    - Ctrl -

6. 显示/隐藏控制台
    - Ctrl + J

7. 新建文件
    - Ctrl + N

8. 关闭当前文件
    - Ctrl + W

9. 重新开一个软件的窗口
    - Ctrl + Shift + N
### 其它快捷键
1. 切换文件
    - Ctrl + Option + 左右方向键
    - Ctrl + Tab （Mac也是这个快捷键）

2. 文件内进行方法或标题间的跳转
    - Ctrl + shift + O

3. 跳转到指定行
    - Ctrl + G （Mac也是这个快捷键）

4. 跳到词首词尾
    - Ctrl + 左右按键    option + 左右按键（Mac）
5. 跳到行首行尾
    - Fn + 左右按键    Cmd + 左右按键（Mac）

6. 在连续的多列上，同时出现光标
    - Ctrl + Alt + 上下键    Cmd + Option + 上下键

7. 代码格式化
    - Alt + shift + F    Option + Shift + F（Mac）

8. 全局搜索内容
    - Ctrl + Shift +F

9. 全局搜索文件
    - Ctrl + P

10. 打开终端
    - Ctrl + `

11. 打开多个终端
    - Ctrl + shift + `
## vscode指令
```bash
# 1. 使用现有的vscode窗口打开一个文件
vscode -r ${filename}

# 2. 比较两个文件的区别
vscode -d ${filename1} ${filename2}

# 下载插件
vscode --install-extension (<extension-id> | <extension-vsix-path>)
```

## 配置
- 所有配置放在.vscode文件夹中
1. 配置文件 settings.json
- https://code.visualstudio.com/docs/languages/identifiers
```json
{
    "some_setting": "custom_value",
    // 文件格式
    "files.associations": {
          "*.mak": "makefile",
          "Jenkinsfile-*": "groovy"

      },
    //  "explorer.autoReveal"
    "http.proxy": "http://127.0.0.1:1080",
    "http.proxyStrictSSL": false
}
```
2. 调试设置 launch.json

3. 任务设置 tasks.json

## 我的插件
1. Better Jinja

2. GitLens — Git supercharged

3. Live Server
    - 静态页面服务器，解决访问第三方js包时的跨域问题

4. Rust相关的插件
    - Rust
    - Debug
        - C++ (Windows)
        - CodeLLDB（Mac或Linux） ~/.vscode/launch.json
5. Bookmarks

## 错误与解决
1. vscode 中 js 文件失去高亮 / 没有智能提示
    - windows删除 AppData\Roaming
    - mac删除 Library/Application Support/Code
    - 这个文件夹爱被删除后，vscode的个人设置都会被删除。
