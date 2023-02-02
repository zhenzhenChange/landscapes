# Functional Programming: Origins

最近脑子一热，想研习一下函数式编程。主要是天天有人抱着函数式喊 React ，不了解一下不然都没底气交（duǐ）流（rén），几番颠簸，决定从 Haskell 开始。

都说学习一门新的语言要从搭建开发环境开始，Haskell 的环境搭建还算比较简单，来来回回折腾了差不多一小时就搞定了（主要是安装必备的依赖花的时间比较久）。

序章看的是《Real World Haskell》在线版的英文手册<sup id="ref1"><a href="#link1">[1]</a></sup>，主要介绍的是函数式编程以及 Haskell 的背景。

后续的正式章节则看的是民间大神们的中文翻译版<sup id="ref2"><a href="#link2">[2]</a></sup>（英文苦逼选手），还算比较齐全的。

至于中文纸质版，据说是有其它大神<sup id="ref3"><a href="#link3">[3]</a></sup>翻译但是夭折了？

## 缘起源落

目前只是看了前面 2 章，但即便如此也令我有了一丝感悟。

Real World 可以直译成“真实世界”，毕竟这本书想表达的应该就是 Haskell 的本质。

但我却想“胡编乱造”一下，起个另类的书名：《缘起源落：Haskell》。

为什么说“缘起”呢？因为序章及其前面一两章中，都披露着函数式编程的几个核心概念：纯函数、副作用与不可变性。

引用[原文](https://book.realworldhaskell.org/read/types-and-functions.html#id582031)的一段话：

> Much of the risk in software lies in talking to the outside world, be it coping with bad or missing data, or handling malicious attacks. Because Haskell's type system tells us exactly which parts of our code have side effects, we can be appropriately on our guard. Because our favoured coding style keeps impure code isolated and simple, our “attack surface” is small.

大意就是：

> 软件的大部分风险都在于与外界进行交互，即处理各种副作用。而 Haskell 能帮我们准确的分析出代码的哪些部分有副作用，最终达到将**无**副作用的代码与**有**副作用的代码进行**隔离**的目的，以此增强软件的稳定性、健壮性。

所以，这里的“缘”代表的是“缘由”亦或是“起源”，寓意为何会出现（需要）函数式编程。

至于“源”就很简单了，顾名思义，表达的就是“真实世界”或“本质”，即本源。

以“缘由”为始，以“本源”为终，为本书的宗旨。

押韵点，缘起源落。

## 核心价值

回到前文提到的几个核心概念：

- 纯函数（Pure Function）：最大可能的限制函数的行为。即纯函数本身就是模块化的，是自洽的，函数越纯，就越容易与非纯函数（有副作用的代码）进行交互以及测试。
- 副作用（Side Effect）：从医学的角度上讲，是指应用治疗量的药物后所出现的治疗目的以外的药理作用，即不良反应。从编程的角度来说，这是一种隐性的依赖关系。函数内部的行为依赖了外部环境（外部作用域），这也就意味着函数的执行会是不稳定的，依赖关系越复杂，不稳定性就越强烈，这也就表明了程序需要做出更复杂的逻辑处理与测试。总而言之，副作用就是达成了主要目的之后，还会额外给外部带来影响。
- 不可变性（Immutable）：Haskell 的求值方式是惰性求值（其它函数式编程语言应该也是吧？），它给变量绑定的是表达式而不是值（表达式直接计算后得出的结果），因此，一个变量（表达式），只有真正需要它时才会去执行。从侧面上看，没有了赋值这个操作（只有绑定），也就意味着数据是不可变的。

另外还有一个跟惰性求值相关的概念：Thunk。

在 Haskell 内部，给函数传递的参数会被层层包装为 Thunk。而在非函数式语言的中，表现的则是高阶函数或者自行实现的柯里化函数。

例如：

```haskell
-- Haskell Code

count a b = a + b

count (1 + 2) 3

-- 等价于

count(1 + 2)(3)
```

那么，`count`函数包装之后形成的 Thunk，用 TS 表达就会是这样的：

```ts
const count = (a: number) => (b: number) => a + b
```

结合`count(1 + 2)(3)`理解：

1. 在执行`count`函数之后，表达式`1 + 2`被绑定给了局部变量`a`，随后返回一个函数；
2. 再次调用返回的函数，`3`被绑定给了局部变量`b`，随后即将执行加法运算；
3. 在执行加法运算之前，发现`a`是个表达式，于是对其进行求值；
4. 将求得的`a`的值与`b`进行加法运算，返回运算结果。

显而易见，在真正执行加法运算`a + b`之前，变量`a`所绑定的表达式`1 + 2`都不会被执行求值。

结合以上概念得出一句经典骚话：**给定同样的输入，有且只有唯一的输出。**

综上，函数式编程的一个核心理念<sup id="ref4"><a href="#link4">[4]</a></sup>在于**隔离副作用**。注意是隔离，而不是推崇无副作用，特别是在工业界，一个标准的软件系统要想不与外界系统进行交互，那估计是不可能的。

## 后话

函数式编程还有大量的数学理论支撑，小步慢走咯~

但，咱先回到 React 身上，为何有人会说它既主打函数式又追求无副作用呢？

这本身就是相悖的，“隔离”又不等于“无”。

## 参考

1. <span id="link1"><a href="#ref1">^</a> Real World Haskell <https://book.realworldhaskell.org/read></span>
2. <span id="link2"><a href="#ref2">^</a> Real World Haskell 中文 <http://cnhaskell.com></span>
3. <span id="link3"><a href="#ref3">^</a> Real World Haskell 翻译夭折 <https://www.zhihu.com/question/27495746/answer/37040419></span>
4. <span id="link4"><a href="#ref4">^</a> 函数式编程的核心价值是什么？ <https://www.zhihu.com/question/471098472></span>
