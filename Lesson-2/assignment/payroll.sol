pragma solidity ^0.4.14;

/**
1.加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，
并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
1个员工 transaction cost:22966gas; execution cost:1694gas
2个员工 transaction cost:23747gas; execution cost:2475gas
3个员工 transaction cost:24528gas; execution cost:3256gas
4个员工 transaction cost:25309gas; execution cost:4037gas
5个员工 transaction cost:26090gas; execution cost:4818gas
6个员工 transaction cost:26871gas; execution cost:5599gas
7个员工 transaction cost:27652gas; execution cost:6380gas
8个员工 transaction cost:28433gas; execution cost:7161gas
9个员工 transaction cost:29214gas; execution cost:7942gas
10个员工 transaction cost:29995gas; execution cost:8723gas
gas有变化，每增加一个员工transaction cost和executoion cost都增加了781gas
因为程序中的for循环是遍历数组 ，数组每增加一个元素都会增加计算量，而这些计算都需要消耗gas

2.如何优化calculateRunway这个函数来减少gas的消耗？ 提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
定义一个storage变量totalSalary，在每次添加、删除、修改员工时计算出当时的总工资。从而取消calculateRunway方法中的遍历
每次消耗稳定在 transaction cost:22124gas; execution cost:852gas
 **/
 
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    //总工资 
    uint totalSalary;

    function Payroll() {
        owner = msg.sender;
    }
    
    /** 发工资给指定员工 **/
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
        
    }
    
    /** 根据员工地址找到该员工 **/
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return(employees[i],i);
            }
        }
        
    }
    
    /** 增加员工  **/
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary*1 ether , now));
        //将工资加入总工资
        totalSalary += salary * 1 ether;
    }
    /** 删除员工  **/
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id !=0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        //将工资从总工资中减去
        totalSalary -= employee.salary;
       
    }
    
    /** 修改员工  **/
    function updateEmployee(address employeeId, uint salary) returns(uint) {
        require (msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        //将工资差额加到总工资中去 
       return totalSalary += (salary * 1 ether - employee.salary);
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
