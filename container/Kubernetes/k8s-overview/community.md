# 社区
- 参考  
https://stupefied-goodall-e282f7.netlify.app/keps/  
https://draveness.me/kubernetes-contributor/

1. SIG(Special Interest Groups)   
特别兴趣小组  
Kubernetes 目前包含 20 多个 SIG，它们分别负责了 Kubernetes 项目中的不同模块。

2. KEP(Kubernetes Enhancement Proposal)  
提案  
因为 Kubernetes 目前已经是比较成熟的项目了，所有的变更都会影响下游的使用者，对于功能和 API 的修改都需要先在 kubernetes/enhancements 仓库对应 SIG 的目录下提交提案才能实施，所有的提案都必须经过讨论、通过社区 SIG Leader 的批准。

4. WG(Working Groups) 工作小组

5. UG(User Groups) 用户小组

## 分布式协作
1. 与公司内部项目的开发模式不同，几乎所有的开源社区都是一个分布式的、松散的组织，这种特殊的场景非常考验项目的管理方式。
2. Kubernetes 中所有的社区会议都会使用 Zoom 录制并上传到 Youtube，大多数的讨论和交流也都会在对应的 issue 和 PR 中。
3. Kubernetes 社区除了提倡公开讨论之外，它还包含功能强大的测试系统，每个提交的 PR 都需要通过两个以上成员的 Review 以及几千个单元测试、集成测试、端到端测试以及扩展性测试，这些测试共同保证了项目的稳定。

## 代码规范
Kubernetes 项目使用 golint 作为静态检查工具