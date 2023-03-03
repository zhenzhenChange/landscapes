新值与旧值

所以，响应式的核心概念只有三个：

1. 拥有一个响应单元
2. 拥有自动响应能力

即 ref + watch，此外还有一个响应衍生的能力，本质上只是 ref + watch 的语法糖。

### 行为、事件、逻辑

很多东西有不同的叫法，只是为了更能体现自己的特性。

### 同步、调度、管理

### 业务交互与视图交互

业务交互 = 业务状态 + 业务逻辑

视图交互 = 视图状态 + 视图逻辑

### 贫血模型与充血模型

### MVVM -> MVI

## 状态管理

什么是管理？一直以来都没有好好思考过这个词的含义，潜意识的只是按照字面意思，认为管理就是维护、约束、集中。

其实不然，管理是指一定组织中的管理者，通过实施计划、组织、领导、协调、控制等职能来协调他人的活动，使别人同自己一起实现既定目标的活动过程。是人类各种组织活动中最普通和最重要的一种活动。

摘取关键词并总结：通过某种手段，控制外部的行为，使其与己协同工作。

在计算机的世界中，这个「某种手段」，就是「调度」。

## 状态同步

## 缘分

createService + fellow student

思考到什么程度？

- 洗澡的时候有时会想一些问题，以致于我回过神之后，却忘记了刚刚到底洗头了没有。
- 坐地铁的时候思考问题，有时候会坐过站，不过现在已经形成了肌肉记忆。
- 过马路的时候也会思考，但这是不好的习惯。

React 要求函数是纯的，但是真实世界中必然会有副作用，于是纯函数与副作用之间需要一种手段进行调度，即 useEffect，setState 就是一个 dispatcher。我们所有的副作用都必须在 useEffect 中处理。computed 是 watch 的简写：

由于 React 每次都会 re-run，当状态未变时直接回 bailout，所以如若某个组件中有复杂的计算，有可能会阻塞渲染，此时 useMemo 就派上用场。

```ts
const count = ref(0)

const computedDouble = computed(() => count.value * 2)

const watchDouble = ref(count.value)
watch(count, (v) => (watchDouble.value = v))
```

- 纯函数
- 副作用
- 不变性

React 和 Vue 新版都在解决 Service 上的问题。

## 什么是 model

贫血模型 - 函数式

充血模型 - 面向对象

angular 才是真正意义上的 MVVM 框架，而 vue 和 react 只是 VM 库

Rxjs 是将人机交互建模为相互依赖的可观察对象。

## 组合和聚合

> <https://github.com/vuejs/docs-next-zh-cn/issues/53>

在函数式编程中，函数是第一类（first class）公民，函数式编程由“行为”和“事件”组成。事件是基于时间的离散序列，而行为是不可变的，是随着时间连续变化的数据。函数式编程与响应式编程相比，它更偏重于底层编码的实现细节。

## 终末

本文横跨了多个技术领域或场景，包含但不仅限于：

- 分层架构（Model View Intent，MVI | Model View ViewModel，MVVM）
- 前端框架（Vue | React | Solid | Angular）
- 数据驱动（Data Driven）
- 事件驱动（Event Driven）
- 状态管理（State Management）
- 状态逻辑管理（State Logic Management）
- 领域驱动设计（Domain-Driven Design，DDD）
- 声明式编程
- 命令式编程
- 响应式编程（Reactive Programming，RP）
- 函数式编程（Functional Programming，FP）
- 函数式响应式编程（Functional Reactive Programming，FRP）
