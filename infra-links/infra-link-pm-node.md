# 包管理器的抉择

本文将结合基准测试结果、跨平台兼容性及项目管理策略，提供一颗决策树，以帮助你在何时何地使用何种包管理器做出权衡。

## 主流包管理器

![pms](images/pms.jpg)

本次基准测试涉及的主流包管理器及其版本为：

- `npm v9`
- `Yarn v1 classic`
- `Pnpm v8`

其中，`Cnpm`由淘宝团队对`npm`进行了优化改造并提供了镜像源和缓存机制，而`Tnpm`则是在`Cnpm`的基础上进一步增强和定制，它们主要应用于企业私有化领域，所以并不算在主流范畴内。

> [Tnpm Rapid](https://zhuanlan.zhihu.com/p/455809528)

随着这几年的发展，`Yarn`已经衍生出两个不同的版本：`Yarn classic`用来表明`v1`的版本，而`Yarn berry`则用来表示`v2`及其以上的版本。

考虑到以下因素，我们仅测试`Yarn classic`版本：

- `Yarn classic`至今为止仍作为默认版本被安装，对于一般开发者，`Yarn berry`的知晓率和使用率都相对较低。

  ![yarn-downloads](images/yarn-downloads.png)

- `Yarn berry`的设计与其它包管理器或是社区生态的发展方向有所不同（非贬义），尽管它也在努力兼容，但一些知名开源库考虑到兼容性问题还是会强制使用`Yarn classic`，比如 [Angular](https://github.com/angular/angular/blob/main/.yarn/README.md)。
- `Yarn berry`与`Pnpm`在特性/功能上有许多相通之处，因此两者的发展方向正逐渐趋近。
- `Yarn berry`的启用过程配置略微繁琐，不利于自动化测试的进行。

基于上述原因，我们只需要对`Pnpm`进行测试即可涵盖对`Yarn berry`的考虑。

## 基准测试结果

将`Yarn`与`Pnpm`的官方基准测试结果作为参考：

- [https://pnpm.io/benchmarks](https://pnpm.io/benchmarks)
- [https://yarnpkg.com/benchmarks](https://yarnpkg.com/benchmarks)

## 跨平台兼容性

## 项目管理策略

## 决策树

> 一切选择皆为权衡（Trade-off）。
