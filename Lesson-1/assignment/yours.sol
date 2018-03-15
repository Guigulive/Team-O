pragma solidity ^0.4.14;

//所以这个作业的业务逻辑是：一个单员工主动领取工资的合约，但一旦换人，前一个员工的工资就是被动发送的结清模式。
contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    //使用结构函数在创建合约时就确定合约所有者
    function Payroll() {
        //msg.sender是函数调用人的地址
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        //只有合约所有者才有权更新地址和薪水，否则就跳出
        if (msg.sender != owner) { 
            revert();
        }
        //如果前一个员工有未结清的工资，则直接计算并发送
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        //将输入的地址和薪水写入变量
        employee = e;
        salary = s * 1 ether;

        //新员工的计薪时间从现在开始
        lastPayday = now;
    }
    
    //读取合约内余额，可以作为合约value"充值"的触发器
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //合约内余额购发当前员工薪水几次
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    //合约内余额够发当前员工薪水一个月薪水
    function hasEnoughFund() returns (bool) {
        return this.balance >= salary;
    }
    
    //
    function getPaid() {
        //如果调用领工资函数的人不是当前设置的员工则跳出，只有当前设置的地址才有权领工资
        if (msg.sender != employee) {
            revert();
        }
        

        uint nextPayday = lastPayday + payDuration;
        
        //如果未到领薪日则跳出
        if (nextPayday > now) {
            revert();
        }

        //更新下次领薪日
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
