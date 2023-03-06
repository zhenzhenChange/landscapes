# State Management

状态管理这个东西，舌根都嚼烂了，还在谈，仿佛是个绕不过去的坎。

我们将以 React 为例，抛开已有的事实，从需求背景出发，推导可行的解决方案，一路追溯到状态管理的由来。

最后再研讨，我们是否真的需要状态管理，以及在未来又该如何演变？

## 背景

## 统一语言

老规矩，先统一语言：状态同步。

回想前一章节所定义的术语表，这里的同步将采用一致性这个定义，即在一个完整的系统中，各个部件中的状态能表现一致。

一个传统的 Web 应用系统，一般包含客户端与服务端。

将其代入到 React 应用中，状态同步会涉及两个部分，即外部同步与内部同步，其也有对应的解决方案：

- 采用事件驱动，将外部数据的变化同步到 React 应用，介入 React 的调度。
- 建立单一数据源，使 React 内的各个组件能共享同一个状态的变化。

[![cs](images/cs.png)](https://excalidraw.com/#json=S6xGNHFm_sqTpGwEwieYu,uytDEryQCOVSV2O8v8IVAA)

## 第一印象

在 React 中，通常有 3 种因素会引起组件重渲染，即 Props、State、Context 中的任意状态发生变更。

```ts
function Example(props) {
  const context = useContext(xxx)

  const [state, setState] = useState(xxx)
}
```

当然，本质上都是调用了`setState`而导致的，而`setState`的内部定义就是`dispatch`，后文还会介绍另外一种特殊的因素。

那么，是否可以将外部的状态直接通过`Props/Context`传递给组件？

例如，构造工厂：

```ts
class LauncherSDK {
  value = 0
}

function createWidget(jsxFactory: (props: LauncherSDK) => ReactJSX) {
  // 或使用依赖注入解除对依赖的直接耦合
  const instance = new LauncherSDK()

  // --------------- 差点什么？ ---------------

  return () => jsxFactory(instance)
}
```

调用方式：

```tsx
function Example(props: LauncherSDK) {
  return <h1>{props.value}</h1>
}

const FinallyExample = createWidget(Example)
```

细嗦上面的例子，有没有很像什么？

```tsx
import { connect } from 'react-redux'

const mapStateToProps = (state: LauncherSDK) => ({ value: state.value })

function Example(props: LauncherSDK) {
  return <h1>{props.value}</h1>
}

export default connect(mapStateToProps)(Example)
```

没错，就是 Redux 的模样。。。

只不过相比较于 Redux 之下，在构造工厂的例子中，我们似乎还差点什么？

还差当外部数据发生变化时，要同步（通知）到 React 应用的能力，即响应式。

## 惯用手法

由于外部数据的变更动作不在 React 的管辖范围内，即这类副作用对于 React 来说是一个黑盒子，它无法感知到外部数据现在是什么情况，这也就意味着 React 没有办法自动（主动捕获）去处理。「**伏笔**」

于是，需要我们开发者「显式」地处理这些副作用，将其与 React 的纯函数组件进行连接交互，即接入到 React 的调度中：

```ts
const [state, setState] = useState(() => store.state)

useEffect(() => store.subscribe((v) => setState(v)), [])
```

也就是说，我们只需要在`createWidget`中加入类似这样一段处理副作用的逻辑，即可达到「同步外部状态」的目的。

而这也是我们在不使用状态管理库的前提下，惯用的做法。试想一下发送一个 http 请求，当请求响应时设置数据并触发更新。

至于「状态共享」就很简单了，设置一个全局的 Store，或是封装成服务，依赖注入即可。

## 权衡其它方案

得益于`Fiber`的应用，在 React 18 中，实现了并发特性，即一次渲染可能会被分为好几个部分并发执行（一个`Fiber`即一个部分）。

例如，在一次渲染中被分为了`A`和`B`两部分，时序如下：

1. `A`和`B`同时读取了一个外部数据源（注意是读取而不是订阅）
2. `A`渲染完成
3. 外部数据源修改了数据（此时`A`的渲染结果是无意义的，值是旧的）
4. `B`渲染完成（此时`B`的渲染结果是有意义的，值是新的）

这个造成同一次渲染中各个部分的结果却不一致的问题，被称为撕裂（Tearing）。

为此，React 18 提供了一个新的 Hook 来解决：`useSyncExternalStore`，即「同步外部数据源」。

`useSyncExternalStore`的前身是`useMutableSource`，叫「订阅外部数据源」。

为什么改名（重新设计）了呢？`useMutableSource`有配套的`createMutableSource`，类似`useContext/createContext`，同时它也不符合并发模式下的渲染逻辑。

在并发渲染中，`useSyncExternalStore`所能做的只是同步刷新视图。也就是当感知到外部数据源发生变更时，之前的部分渲染结果作废，整个渲染任务全部丢弃，同时转变为同步模式，从头开始，即本次渲染不能再应用并发特性，直到渲染完成。而在同步模式下则有可能会阻塞浏览器渲染，引发性能问题。

> `useSyncExternalStore`本质上也是基于`useEffect`的封装。

`useSyncExternalStore`

```ts
// subscribe 用来收集当前订阅了数据源的节点（Fiber）
const state = 0
const listeners = []

// 收集订阅者
const subscribe = (fiber) => {
  listeners.push(fiber)

  return () => listeners.filter((v) => v !== fiber)
}

// 更新状态 + 通知更新
const updateState = () => {
  state++

  listeners.forEach((v) => v())
}

const externalState = useSyncExternalStore(subscribe, () => state)
```

因此，这也是能引发组件重渲染的另一种因素。

## 完整流程

![Yolo](images/Yolo.jpg)

外部（External）与消费端（Framework）：

首先，需提供事件类型（Event）及其对应的数据模型定义（State Interface），用于消费端发起订阅，定制消费逻辑。

其次，还需提供触发该事件的方法（Dispatcher），用于消费端主动变更外部数据，然后外部再通过事件流将变化后的数据同步回消费端，形成环路。

到这里就会发现，此模式跟 Flux 的模式基本一致：

![Flux](images/Flux.png)

然而不同的是，视图不能直接消费订阅而来的数据，因为一旦直接对数据进行消费，就会：

1. 丧失了对逻辑的封装能力，即 Model 成为一个贫血模型，其行为（逻辑）分散在视图各地，无法复用或移植，且不利于测试。
2. 逻辑过度依赖数据，换句话说逻辑会依赖视图是如何的表现，没有数据定义就无法进行逻辑处理，而视图是实现细节，是极其不稳定的。

综上，需将状态和逻辑封装成服务，根据实际情况应用单例或者多例，再提供给视图消费。

回到上文提到的一个「伏笔」，结合这一整个流程，会发现这一套架构模式，就是 Angular 的架构。

之前有提到，React 无法主动处理副作用，因为它不知道这个黑盒到底「做了什么」，需要开发者手动介入 React 的调度。

而 Angular 不同，它不需要知道你到底做了什么，它只需要知道你到底「做了没有」。也就是说数据的改变都会有一个缘由，不管是手动触发，还是定时器未来自动触发，本质上都是基于事件回调机制（异步）。

于是 Angular 用 Zone 暴力劫持浏览器的各类异步事件、任务。当事件触发时，全局范围内保守式地检查所有组件所用到的状态是否发生了变化，若变化则标记为脏，用以后续执行重渲染流程。

相应的也需要付出代价：在运行时进行脏检测会有性能问题。

最后，Angular 还提供了一套依赖注入机制，用于将业务交互与视图交互解耦。

所以，在 Angular 的应用中不需要状态管理，状态依托于服务。

## 参考资料

- [What is tearing?](https://github.com/reactwg/react-18/discussions/69)
- [Concurrent React for Library Maintainers](https://github.com/reactwg/react-18/discussions/70)
- [useMutableSource → useSyncExternalStore](https://github.com/reactwg/react-18/discussions/86)
- [如何理解 React 18 中的 useSyncExternalStore ?](https://www.zhihu.com/question/502917860/answer/2252338680)
