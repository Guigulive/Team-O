/*作业请提交在这个目录下*/

//使用mapping重写程序
pragma solidity ^0.4.14;

contract Payroll {

    address owner;
    uint constant payDuration = 10 seconds;

    uint totalSalary;


    struct  Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }

    // Employee[] employees;
    mapping(address => Employee) employees;

    function _partialPay(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayDay) * payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeID) private returns (Employee){
        return employees[employeeID];
    }

    function addEmployee(address employeeID, uint salary){
        require(msg.sender == owner);
        var employee  = _findEmployee(employeeID);
        assert(employee.id == 0x00);
        employees[employeeID] = Employee(employeeID, salary * 1 ether, now);
        totalSalary += salary;
    }


    function removeEmployee(address employeeID){
        require(msg.sender == owner);
        var employee = employees[employeeID];
        assert(employee.id != 0x00);
        _partialPay(employee);
        delete employees[employeeID];
    }

    function updateEmployee(address employeeID, uint salary){
        require(msg.sender == owner);

        var e = _findEmployee(employeeID);
        require(e.id != 0x00);

        _partialPay(e);
        totalSalary -= employees[employeeID].salary;
        employees[employeeID].id = employeeID;
        employees[employeeID].salary = salary;
        totalSalary += salary;

    }

    function getPaid() payable public{
        var e = _findEmployee(msg.sender);
        require(e.id != 0x00);
        require(e.lastPayDay + payDuration < now);

        e.lastPayDay = now;
        e.id.transfer(e.salary);
    }

    function Payroll() public{
        owner = msg.sender;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }



    function calculateRunaway()  public returns (uint){
        // uint totalSalary = 0;
        // for(uint i = 0; i < employees.length; i++){
        //     totalSalary += employees[i].salary;
        // }

        // require(totalSalary != 0);

        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool){
        return calculateRunaway() > 0;
    }


}
