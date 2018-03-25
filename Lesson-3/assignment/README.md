## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

```sol
mro(O) = [O]
mro(A) = [A, O]
mro(B) = [B, O]
mro(C) = [C, O]

mro(K1) = [K1] + merge(mro(A), mro(B), [B, A])
        = [K1] + merge([A, O], [B, O], [B, A])
        = [K1, B] + merge([O], [A, O], [A])
        = [K1, B, A] + merge([O], [O])
        = [K1, B, A, O]

同理
mro(K2) = [K2, C, A, O]

mro(Z) = [Z] + merge(mro(K1), mro(K2), [K1, K2])
       = [Z] + merge([K1, B, A , O], [K2, C, A, O], [K2, K1])
       = [Z, K2] + merge([K1, B, A, O], [C, A, O], [K1])
       = [Z, K2, C] + merge([K1, B, A, O], [A, O], [K1])
       = [Z, K2, C, K1] + merge([B, A, O], [A, O])
       = [Z, K1, C, K1, B] + merge([A, O], [O])
       = [Z, K2, C, K1, B, A, O]
```
