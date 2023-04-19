# 基准测试结果

> 为确保测试顺利进行，请保持网络畅通。如果网络受阻，安装过程将会不断重试，这将直接影响到耗时统计。

## 测试目标

|  command  | cache | lockfile | node_modules |
| :-------: | :---: | :------: | :----------: |
| `install` |       |          |              |
| `install` |   ✔   |    ✔     |      ✔       |
| `install` |   ✔   |          |              |
| `install` |       |    ✔     |              |
| `install` |       |          |      ✔       |
| `install` |   ✔   |    ✔     |              |
| `install` |   ✔   |          |      ✔       |
| `install` |       |    ✔     |      ✔       |

|  command  | cache | lockfile | node_modules |        note        |
| :-------: | :---: | :------: | :----------: | :----------------: |
| `install` |   ✔   |    ✔     |      ✔       | 前提：保证工件完整 |
| `dynamic` |  N/A  |   N/A    |     N/A      | 增删改依赖（版本） |

## MacOS

## Windows 11

## Windows 10 - WLS2 - Ubuntu 18.04.5
