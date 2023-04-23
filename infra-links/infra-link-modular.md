# 模块化思维模式

实际上，模块化开发思想可能一直存在于每一位程序员的意识中，但在实际开发中，可能并没有完全遵循一些所谓的方法论，或者更确切地说，大部分情况下缺乏实际的标准参照。

## 高内聚低耦合

模块化设计的核心要素之一就是高内聚低耦合。

- 高内聚，指模块内部的元素（如属性、方法、枚举、视图等）彼此之间联系紧密，共同完成一个明确的功能；
- 低耦合，指模块之间的相互依赖性应最小化，同时伴有合理的交互方式，一个模块的变化应尽可能的减少对另一个模块的影响。

高内聚低耦合是模块化设计的充分必要条件，它对模块的可移植性、可维护性、可重用性等其它特性有直接影响。

## 实际案例

通常，在正式开发业务功能之前，我们会收到原型图或设计图（脑补也不是不可以）。下面，我们将从惯用思维和模块化思维两个方面，对以个简单的案例进行分析，先看设计图。

### 课程模块

一个带有搜索排序的课程列表，点击某项课程，进入课程「实体」页面，该课程实体伴有内容详情、教学资源、作业考试、课程表、课程目录、课程讨论等子功能。

![modular-fixed-1](images/modular-fixed-1.png)

![modular-fixed-2](images/modular-fixed-2.png)

## 惯用思维

通常情况下，我们会按照视图排版来设计目录结构，因为这是心智负担最低的一种方式。

例如：

```tree
src
├─ services
│    ├─ course.ts
│    └─ project.ts
├─ stores
│    ├─ course.ts
│    └─ project.ts
└─ views
       ├─ course
       │    ├─ item.tsx
       │    ├─ list.tsx
       │    └─ styled.tsx
       └─ project
```

从分层架构的角度来看，这种做法似乎较为合理。

然而，随着时间的推移和业务复杂度的提升，这种项目结构就可能会变得难以掌控，演变为“分文件夹架构”：

```tree
src
├─ services
│    ├─ course.ts
│    └─ project.ts
├─ stores
│    ├─ course
│    │    ├─ comment
│    │    └─ resource
│    └─ project
└─ views
       ├─ course
       │    ├─ comment
       │    ├─ item.tsx
       │    ├─ list.tsx
       │    ├─ resource
       │    └─ styled.tsx
       └─ project
```

嵌套结构与功能之间的相互引用无处不在，但是更多的是体现在业务代码中，通过目录结构可无法轻易观察得到。

而这样的一个目录结构并不符合模块化设计的标准，一个模块所需的元素被分散在各地，想要汇总起来简直是天方夜谭。

> **即，分文件夹架构是离散的。**

试想，一个模块内的某个子功能需要在其它模块被复用，或者一整个模块需要被移植到其它项目，应该怎么办？短时间内恐怕很难理清各个模块之间的依赖关系，以便「挑选」出仅需的模块。

这种情况最终会导致项目变得越来越臃肿、庞大，可复用性和可维护性显著降低，可移植性几乎为 0（或者说移植的粒度便是整个项目）。

### 问题归因

难道分层架构存在问题吗？前人的理论是否存在错误？或许分层架构并不适合大型项目？是否应该考虑其它方式呢？

**No，分层架构本身并没有问题，演变成分文件夹架构是由于抽象的层次过低与边界划分模糊所导致的。**

分层中的层（Layer），是指抽象程度不同的层次，抽象程度越高的层次就越具有概括性和更抽象化。

![abstract](images/abstract.jpg)

物以类聚人以群分是一种常见的社会现象，虽说将其代入到软件领域中有一定的指导意义，但软件开发中的因素是变化多端且不稳定的。

接下来便探讨可行的解决方案。

## 思维转变

将离散的元素重新聚合，使其符合模块化设计的高内聚性标准。

也许你会有这样的疑问：既要分层，又要内聚，难道不会相互冲突吗？

不会，因为它们的作用对象不同，用熟悉的话语来说就是它们的作用域不同。

先看转变后的结果：

```tree
src
├─ layout
└─ modules
       ├─ course
       │    ├─ course.component.tsx
       │    ├─ course.model.ts
       │    ├─ course.module.tsx
       │    ├─ course.service.ts
       │    └─ course.styled.tsx
       └─ project
```

熟悉 Angular 的朋友一眼丁真，这就是 NG 一直以来所贯彻的最佳实践：模块化开发。

而现在我们只是将这个最佳实践「复刻」到其它视图库中，如 React。至于一些必备的特性该如何实现，如前文提到的合理的交互方式，我们会在后续提及。

与前文介绍的传统目录结构相比，有一个明显的不同点：文件命名。为了突出不同层次的文件功能，文件名增加了特性（部分是抽象层次）标识，即`[module].[layer/feature].[suffix]`。而采用模块名作为前缀是为了区分这些特性是属于哪一个模块，毕竟一个模块下还可能会有其它子模块。

回到刚刚，分层便是指对一个模块的代码元素进行区分，而聚合则是将这些元素聚合在一个文件夹中，使其不会扩散并影响到其它模块。

**即，分层针对的是代码结构，而聚合则针对的是目录结构（模块/系统结构）。**

## 模块交互

模块解耦之后，还需要通过某种方式进行交互联系，常见的交互方式有事件驱动、依赖注入、发布订阅等。

通过这些交互方式，模块在实现更加灵活、可扩展的功能的同时，还能保持模块之间的耦合松散，从而提高整个系统的可维护性与可扩展性等。

与其它交互方式相比，语言提供的模块导入导出机制并不算是一种可靠的交互方式，因为这种引用方式并没有太多的约束。它只是提供一个简单的接口，允许模块之间进行基本的交互，但无法限制模块之间的依赖关系和接口协议的具体标准。

以下主要介绍依赖注入。

### 依赖注入

依赖注入（Dependency Injection，DI）是一种设计模式，通过将依赖关系从「主动」调用转变为「被动」注入的方式，以达到解耦的目的。

- 主动调用意味着依赖方与被依赖方<强>关联，即依赖方与被依赖方之间是<组合>关系。
- 被动注入意味着依赖方与被依赖方<弱>关联，即依赖方与被依赖方之间是<聚合>关系。

#### 混入 vs 组合 vs 聚合

在此之前，我们先看看什么是混入（Mixin）：

```js
function Parent() {
  return { a: 1, b: 2, c: 3 }
}

function Child() {
  return {
    ...Parent(),
    b: 'b',
    d: 'd',
  }
}
```

混入与继承异曲同工，使用不当容易造成命名冲突、来源混乱、数据覆盖等问题。

再来看组合：

```js
function Parent() {
  return { a: 1, b: 2, c: 3 }
}

function Child() {
  return {
    parent: Parent(),
    b: 'b',
    d: 'd',
  }
}
```

组合与混入的区别就是，它多了一个命名空间！嗯哼，组合优于继承并不是空穴来风。

最后是聚合：

```js
function Parent() {
  return { a: 1, b: 2, c: 3 }
}

const p = Parent()

function ChildA() {
  return {
    parent: p,
    b: 'b',
    d: 'd',
  }
}

function ChildB() {
  return {
    parent: p,
    b: 'b',
    e: 'e',
  }
}
```

在聚合的示例中，我们将被依赖方的生命周期提前了（也可以理解为作用域提升了）。

综上所述，组合关系是生命周期强关联的，一荣俱荣一损俱损；而聚合关系是生命周期无关的或者弱关联的，一方生与灭不会影响另一方。

就依赖注入而言，便是将被依赖方置于一个容器中，同时在依赖方需要引入时再将其初始化（惰性初始化）后传入，从而达到依赖关系转变的目的。

#### 代码实现

Angular 有通过编译手段实现的依赖注入机制，非常灵活与易用。

而在 React 中也有类似的 API 提供，只不过我们需要进一步封装：

- 提供类型支持
- 内聚提供与注入功能
- 内置 Token 的管理，降低需要维护 Token 的心智负担

```tsx
// @file: soa.tsx

import { createContext, ProviderProps, useContext, useMemo } from 'react'

interface ServiceProviderProps<P, R> extends Partial<ProviderProps<R>> {
  deps?: P
}

export function createService<P extends any[], R>(service: (...args: P) => R) {
  const ServiceContext = createContext(service.name as unknown as R)

  ServiceContext.displayName = service.name || 'UnknownService'

  const Provider = (props: ServiceProviderProps<P, R>) => {
    const { deps, value, children } = props

    const provideValue = value ?? service(...(deps ? deps : ([] as unknown as P)))

    return useMemo(() => {
      return <ServiceContext.Provider value={provideValue}>{children}</ServiceContext.Provider>
    }, [provideValue, children])
  }

  const useInject = () => {
    const instance = useContext(ServiceContext)

    if (instance === null) throw new Error('Cannot inject before provided.')

    return instance
  }

  return {
    Provider,
    useInject,
  }
}
```

#### 使用案例

结合前文提到的模块示例对上述实现做进一步阐述。

```ts
// @file: course.service.ts

import { useState } from 'react'

import { createService } from './soa'

export function useCourseService() {
  const [data, setData] = useState([])

  // do something ...

  // return something ...
  return { data }
}

export const CourseService = createService(useCourseService)
```

```tsx
// @file: course.module.tsx

import { Course } from './course'
import { CourseService } from './course.service'

export function CourseModule() {
  return (
    <CourseService.Provider>
      <Course />
    </CourseService.Provider>
  )
}
```

```tsx
// @file: course.tsx

import { Fragment } from 'react'

import { CourseService } from './course.service'

export function Course() {
  // inject something ...
  const { data } = CourseService.useInject()

  return (
    <Fragment>
      <CourseHeader />
      <CourseList dataSource={data} />
    </Fragment>
  )
}
```

此时当视图需要该模块时，只需要引入`CourseModule`组件即可。

如若该视图组件不满足需求，仍然可以只引入`useCourseService`和`CourseService`，做一个属于自己的`CustomCourseModule`。

即，当视图与逻辑分离之后，逻辑可单独复用，这就是依赖注入的威力所在。

> 有关视图与逻辑分离的内容后续再探讨。

## 总结

模块化开发思维虽然涉及的知识繁多，学习曲线较陡，心智负担较重，但若掌握之后，可在开发工作中起到关键作用，在开发路途中如履薄冰，并且这种开发思想不受语言限制。

本文的内容旨在播下一个种子，相信这会是一次值得投资的行动。
