## 硅谷live以太坊智能合约 第四课作业
这里是郭乔同学提交作业的目录

### 第四课：课后作业
- 将第三课完成的payroll.sol程序导入truffle工程
- 在test文件夹中，写出对如下两个函数的单元测试：
- function addEmployee(address employeeId, uint salary) onlyOwner
- function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)
- 思考一下我们如何能覆盖所有的测试路径，包括函数异常的捕捉
- (加分题,选作）
- 写出对以下函数的基于solidity或javascript的单元测试 function getPaid() employeeExist(msg.sender)
- Hint：思考如何对timestamp进行修改，是否需要对所测试的合约进行修改来达到测试的目的？

完成作业情况：
- 已经将Payroll.sol程序导入truffle工程，并且完成了addEmployee（）和removeEmployee()函数的单元测试，详见上传的文件。如果把这两个函数的单元测试程序分成两个文件，则removeEmployee函数传入的地址总是0x0, 推测可能是第二次获得的instance与第一次的不一样了；如果把这两个函数的单元测试程序合并为一个文件，则测试通过。
- 为完成以上测试，在Payroll.sol中增加checkEmployee()函数
- 第三题在找等待10秒的解决方案，还未完成。
