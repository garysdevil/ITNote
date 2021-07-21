# vscode
- 参考文档  
https://geek-docs.com/vscode/vscode-tutorials/what-is-vscode.html

## 基本操作
1. 命令面板：VS Code 的绝大多数命令都可以在命令面板里搜到   
    打开方式 F1 或者“Ctrl+Shift+P”

2. 

## vscode指令
```bash
# 1. 使用现有的vscode窗口打开一个文件
vscode -r ${filename}

# 2. 比较两个文件的区别
vscode -d ${filename1} ${filename2}
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
}
```
2. 调试设置 launch.json

3. 任务设置 tasks.json

## 快捷键 
https://www.cnblogs.com/bindong/p/6045957.html
1. 折叠和展开
    1. 折叠所有区域代码的快捷键
        先按下  ctrl 和 K，再按下 ctrl 和 0
    2. 展开所有折叠区域代码的快捷键
        先按下  ctrl 和 K，再按下 ctrl 和 J

## 插件
1. Better Jinja

2. 