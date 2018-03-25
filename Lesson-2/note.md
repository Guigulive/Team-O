# lesson2

## 错误检测

基本一致，语义区别

+ assert(bool) 程序运行时判断
+ require(bool) 程序输入值判断

## 数组

+ 固定  unit[5] a
+ 动态（自动扩容x2） unit[] a
+ 成员
  + length
  + push 动态

## struct

类 c 语法

## 数据存储 EVM

+ storage   区块链持久化空间
+ memory    函数内部
+ calldata  类似 memory

规定：

+ 状态： storage
+ 函数输入：calldata
+ 函数返回参数： memory

## 存储管理

## 答疑杂记

+ `this.balance` -> `address(this).balance` 显示强转，隐式继承后需要强转为父类
+ constant -> view(无法修改全局状态) + pure（纯函数） -> 视觉警示，执行不做检查
+ 远程调用改变全局状态 -> stateMutability: 'nonpayable'， runtime 无检查，考虑到 gas 消耗
+ 回滚 revert
+ gas limit 测试 -> 手动设置 - ？ 测试部署
+ transaction cost 和 execution cost 的区别
  + transaction: 1. 发送函数名，调用参数 2. 传参 3. 初始化创建
  + execution: 程序过程中 Operation Code 需要的 gas（100多种：根据对于 memory 的操作进行分类）
+ Transaction cost 中 zerodata 和 nonzerodata 指的是？
  zerodata 表示没有任何附属的 data，只是一个简单的 value transfer
+ local variable 花钱比 storage 少很多
+ 虚拟机实现方式： stack based 和 register based；EVM 使用的是 stack based 虚拟机，对于区块链这样线性执行的架构，stack based是有一些天然的好处。尤其在 memory 的 mapping上
+ 合约部署后进行升级？分布式治理的问题？
+ 每个 transaction 都是对当下block的状态负责的
