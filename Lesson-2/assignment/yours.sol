/*
第1题：加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
答：由于remix无法登陆，没有进行测试，但应该是每次调用，gas都增加。

第二题：如何优化calculateRunway这个函数来减少gas的消耗？ 提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
答：calculateRunway函数优化：将以前交易计算中的中间结果记录下来，这样就不用重复计算了。
    以下为代码 */


pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment);

    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return(employees[i],i);
            }
        }

    }

    /* add */
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary*1 ether, now));
    }

    /* remove *、
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id !=0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    /* 修改 */
    function updateEmployee(address employeeId, uint salary) {
        require (msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }


    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
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
