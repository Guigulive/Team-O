# solidity

静态类型

## 类型

+ bool
+ int/uint(没有浮点数)
+ address（balance, transfer(val),send(val), call(), callcode, delegatecall）

注意： constant 只能对常规变量进行约束， 不能约束函数返回

## 关键字

+ constant
+ payable
+ this
+ revert

## 全局变量

+ wei // 最小单位
+ szabo = 10 ^ 12 wei
+ finney = 10 ^ 15 wei
+ ether = 10 ^ 18 wei


## block

+ block.blockhash(unit blockNumber) return (bytes32)
+ block.coinbase(address)
+ block.difficulty(unit)
+ block.gaslimit(unit)
+ block.number(unit)
+ block.timestamp(unit) 1970-01-01
+ now

## msg

+ msg.data
+ msg.gas(unit)
+ msg.sender(address)
+ msg.sig
+ msg.value(unit)

## 系统设计

+ 同步调用方式，每个区块的执行都是完整调用
+ 外部定时器调用

## 异常

+ throw  消耗 gas
+ revert 回滚状态，回退 gas

## 优化

+ 变量缓存
+ 作用域：局部变量
+ msg.sender： 函数调用者的信息
