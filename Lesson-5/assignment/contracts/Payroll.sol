pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable{

    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint totalSalary;
    uint totalEmployee;
    address[] employeeList;
    mapping(address => Employee) public employees;

    uint constant payDuration = 10 seconds;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    /* 新增modifier */
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    /* 员工不能修改合约的支付地址，只能修改自己接收salary的地址 */
    function changePaymentAddress(address newId) employeeNotExist(newId) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        require(employee.id == msg.sender);
        require(newId != 0x0);
        uint money = employees[employee.id].salary;
        uint payDay = employees[employee.id].lastPayday;
        delete employees[employee.id];
        employees[newId] = Employee(newId, money, payDay);
    }

    function _partialPaid(Employee employee) private {
        /* uint payment = employee.salary * (now - employee.lastPayday)/payDuration; */

        uint payment = employee.salary
            .mul(now.sub(employee.lastPayday))
            .div(payDuration);

        employee.id.transfer(payment);
    }

    /* 新增checkEmployee函数 */
    function checkEmployee(uint index) returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }


    /* 增加modifier employeeNotExist进行校验 */
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        /* var employee = employees[employeeId]; */

        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
    }

    /* remove */
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        totalEmployee = totalEmployee.sub(1);
    }


    /* get employee address */
    function getEmployee(address employeeId) public returns (address) {
        var employee = employees[employeeId];
        return (employee.id);
    }

    /* check employee address */
    function ifExistEmployee(address employeeId) public returns (bool) {
        var employee = employees[employeeId];
        return (employee.id != 0x0);
    }

    /* 修改 */
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId)  {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
    }


    function addFund() payable returns (uint) {
        return this.balance;
    }
    function calculateRunway() returns (uint) {

        /* return this.balance / totalSalary; */
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        /* uint nextPayday = employee.lastPayday + payDuration; */
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
	assert(this.balance > employee.salary);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;

        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }

}
