| employee count | transaction cost | execution cost |
| :------------- | :------------- | :------------- |
|1   | 22966  | 1694  |   |
|2   | 23747  | 2475  |   |
|3   | 24528  | 3256  |   |
|4   | 25309  | 4037  |   |

### Gas 消耗

`transaction cost`是将合约代码发送到区块链上所消耗的gas，依赖于合约的大小
`execution cost`是evm真正执行这段合约代码所消耗的gas

```solidity
function calculateRunway() returns (uint) {
    uint totalSalary = 0;
   for (uint i = 0; i < employees.length; i++) {
        totalSalary += employees[i].salary;
    }
    return this.balance / totalSalary;
}
```

这段代码对employees数组进行遍历计算总额，时间复杂度为O(n)。所以随数组扩大，`execution cost`相应增大。

## 优化后消耗

| employee count | transaction cost | execution cost |
| :------------- | :------------- | :------------- |
|1   | 22102  | 830  |   |
|2   | 22102  | 830  |   |
|3   | 22102  | 830  |   |
|4   | 22102  | 830  |   |
|5   | 22102  | 830  |   |
