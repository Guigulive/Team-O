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

    modifier ownerOnly{
        require(msg.sender == owner);
        _;
    }

    modifier userExist(address employeeID){
        var employee  = _findEmployee(employeeID);
        assert(employee.id != 0x00);
        _;
    }

    // Employee[] employees;
    mapping(address => Employee) employees;

    function _partialPay(Employee employee) private{
        // uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        // employee.id.transfer(payment);
    }

    function _findEmployee(address employeeID) private returns (Employee){
        return employees[employeeID];
    }

    function addEmployee(address employeeID, uint salary) ownerOnly  public{
        var employee  = _findEmployee(employeeID);
        require(employee.id == 0x00);
        employees[employeeID] = Employee(employeeID, salary * 1 ether, now);
        totalSalary += salary;
    }


    function removeEmployee(address employeeID) ownerOnly userExist(employeeID) public{
        var employee = employees[employeeID];
        _partialPay(employee);
        delete employees[employeeID];
    }

    function updateEmployee(address employeeID, uint salary) ownerOnly userExist(employeeID) public{
        var e = _findEmployee(employeeID);

        _partialPay(e);
        totalSalary -= employees[employeeID].salary;
        employees[employeeID].id = employeeID;
        employees[employeeID].salary = salary;
        totalSalary += salary;

    }

    function changePaymentAddress(address employeeID, address newEmployeeID) ownerOnly userExist(employeeID) public{
        var e = _findEmployee(employeeID);

        var newEmployee = Employee(newEmployeeID, e.salary, e.lastPayDay);
        delete employees[employeeID];
        employees[newEmployeeID] = newEmployee;
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
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool){
        return calculateRunaway() > 0;
    }


}
