## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
答：
1)消耗记录如下
1：tx gas 22971; exe gas 1699
2：tx gas 23759; exe gas 2487
3：tx gas 24547; exe gas 3275
4：tx gas 25335; exe gas 4063
5：tx gas 26123; exe gas 4851
6：tx gas 26911; exe gas 5639
7：tx gas 27699; exe gas 6427
8：tx gas 28487; exe gas 7215
9：tx gas 29275; exe gas 8003
10：tx gas 30063; exe gas 8791

2)每次新增一个员工后gas消耗增加，因为遍历算法会增加计算成本。

- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
答：将totalSalary存储在storage，在add、remove、update函数中，对其再进行改写。这样就无需遍历计算了。
