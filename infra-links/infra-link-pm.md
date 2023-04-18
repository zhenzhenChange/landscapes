# 包管理器的抉择

本文将结合基准测试结果、跨平台兼容性及项目管理策略，提供一颗决策树，以帮助你在何时何地使用何种包管理器做出权衡。

## 主流包管理器

![pms](images/pms.jpg)

本次基准测试涉及的主流包管理器及其版本为：

- `npm v9`
- `Pnpm v8`
- `Yarn v1 classic`

其中，`Cnpm`由淘宝团队对`npm`进行了优化改造并提供了镜像源和缓存机制，而`Tnpm`则是在`Cnpm`的基础上进一步增强和定制，它们主要应用于企业私有化领域，所以并不算在主流范畴内。

> 相关资料：[Tnpm Rapid](https://zhuanlan.zhihu.com/p/455809528)

随着这几年的发展，`Yarn`已经衍生出两个不同的版本：`Yarn classic`用来表明`v1`的版本，而`Yarn berry`则用来表示`v2`及其以上的版本。

考虑到以下因素，我们仅测试`Yarn classic`版本：

- `Yarn classic`至今为止仍作为[默认版本](https://www.npmjs.com/package/yarn?activeTab=versions)被安装，对于一般开发者，`Yarn berry`的知晓率和使用率都相对较低。

  ![yarn-downloads](images/yarn-downloads.png)

- `Yarn berry`的架构设计与其它包管理器或是社区生态的发展方向有所不同（非贬义），尽管它也在努力兼容，但一些知名开源库考虑到兼容性问题还是会强制使用`Yarn classic`，比如 [Angular](https://github.com/angular/angular/blob/main/.yarn/README.md)。
- `Yarn berry`与`Pnpm`在特性/功能上有许多相通之处，同时两者的发展方向也正逐渐趋近。
- `Yarn berry`的启用过程配置略为繁琐，不利于进行通用的自动化测试。

基于上述原因，我们只需要对`Pnpm`进行测试即可涵盖对`Yarn berry`的考虑。

> 如果你想了解`Yarn berry`的基准测试结果，可以参考下文中`Yarn`与`Pnpm`的官方基准测试，或是对自动化测试项目的源代码进行修改以进行测试。

## 基准测试结果

### 基准测试参考与实现

将`Yarn`与`Pnpm`的官方基准测试结果作为参考：

- [https://pnpm.io/benchmarks](https://pnpm.io/benchmarks)
  - [benchmark script](https://github.com/pnpm/pnpm.github.io/tree/main/benchmarks)
- [https://yarnpkg.com/benchmarks](https://yarnpkg.com/benchmarks)
  - [benchmark script](https://github.com/yarnpkg/berry/blob/master/scripts/bench-run.sh) - 该基准测试仅在`Linux`环境下进行

自行实现的自动化测试项目参考了官方的测试脚本并经过优化，使其具备跨平台测试的能力，且更具有扩展性：[control-variates](https://github.com/zhenzhenChange/control-variates)。

> 鉴于篇幅限制，你可以在[附录](./infra-link-pm-benchmarks.md)中查看更详细的基准测试结果。

### 包管理器侧重点对比表

根据基准测试结果得出的包管理器侧重点对比表：

| installer | cache  | lockfile | node_modules |
| :-------: | :----: | :------: | :----------: |
|   `npm`   |        |          |    💥💥💥    |
|  `Yarn`   |        |  💥💥💥  |              |
|  `Pnpm`   | 💥💥💥 |          |              |

其中：

- `npm`主要关注`node_modules`的可用性，只要所需依赖能被正确安装即可
- `Yarn`更注重维持`lockfile`的一致性，确保在不同环境或多次安装时能获得一致的依赖结构
- `Pnpm`则更强调充分利用`cache`以提高安装效率，减少磁盘的占用，同时解决依赖污染等问题

## 跨平台兼容性

除了`Pnpm`之外，其它两个主流包管理器在跨平台兼容性方面表现出色。

`Pnpm`在安装依赖时采用软硬链接方式将依赖项从全局存储库链接到项目中。而在`Windows`环境下，由于软链接存在一定的兼容性问题，`Pnpm`采用了其它[解决方案](https://pnpm.io/faq#does-it-work-on-windows)替代。

因此，就`Windows`环境而言，使用`Pnpm`安装依赖的性能有可能不如`Yarn`，甚至更差（取决于机器的硬件性能）。

> 在极端情况下，还可能会导致`Windows`操作系统卡死崩溃，目前还无法知晓问题的确切原因（`Pnpm`作者也不确定 🤣），感兴趣请追踪：<https://github.com/pnpm/pnpm/issues/6298>

## 项目管理策略

## 决策树 & 收益表

> 一切选择皆为权衡（Trade-off）。
