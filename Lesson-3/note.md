# Lesson3

## MAPPING

+ 类似 c++ 中的 map, python 中的 dict
+ key: 1. bool, 2. int, 3. address, 4. string
+ value
+ mapping(address => Employee) employees
+ 只能做成员变量，不能做局部

底层

+ 底层不是 数组活链表
+ hash函数为 keccak256hash，在 storage上存储，理论无限大的 hash 表
+ 局限：无迭代器
+ value 是引用，在 storage 上存储，可以直接修改
+ key 不存在时，返回 默认值

## 命名函数

命名的返回参数可以不需要 `return`

## 可视度与继承

+ public
+ external: 只有 “外部调用可用”
+ internal：外部调用不可见，内部和子类可见
+ private：当前合约可见

状态变量：public,internal,private

+ public 自定义取值函数
+ internal 默认
+ private 不代表别的无法肉眼看到，只代表别的区块链智能合约无法看到

函数

+ public 默认
+ external 内部无法调用，只能供外部使用 `this.fun()` 改变成外部调用，但耗费更多 `gas`

## 继承

```sol

contract owned {
    address owner;
    function owned() {
        owner = msg.sender;
    }
}

contract Parent is owned {
    unit x;
    function Parent(unit _x) {
        x = _x;
    }
}
```

### 抽象合约

类似 abstract

### interface

### 多继承

super 动态绑定父类的指针

+ 多继承 Method Resolution Order 使用 C3 Linearization，继承不能出现环路

## Modifier

类似装饰器

```sol
modifier onlyOwner {
  require(msg.sender == owner);
  _; // 被修饰代码位置，如果放在上面，则表示 return 前的代码
}
```

## 相关库

+ zeppelin-solidity

`import './xxx'`

## C3 线性化

概念：计算机编程红用于在多继承中确定继承方法的顺序，即 `方法解析顺序` (Method Resolution Order, MRO)

三个属性

+ 一致扩展前趋图
+ 本地前驱序的保持
+ 适于单调标准

C3 算法

+ 如果继承至一个基类： `class B(A): mro(B) = [B, A]`
+ 继承多个基类：`class B(A1, A2, A3){}`
  `mro(B)= [B] + merge(mro(A1), mro(A2), mro(A3), ..., [A1, A2, A3 ...])`
  遍历执行 merge 操作的序列，如果一个序列的第一个元素，是其他序列中的第一个元素，或不在其他序列出现，则从所有执行 merge 操作序列中删除这个元素，合并到当前的 mro 中。merge 操作后的序列，继续执行 merge 操作，直到 merge 操作的序列为空。如果 merge 操作的序列无法为空则说明不合法

## reference

+ [C3线性化](https://zh.wikipedia.org/wiki/C3%E7%BA%BF%E6%80%A7%E5%8C%96)
+ [Implementing C3 Linearization](https://xivilization.net/~marek/blog/2014/12/08/implementing-c3-linearization/)
+ [python多重继承新算法C3](http://www.cnblogs.com/mingaixin/archive/2013/01/31/2887190.html)
