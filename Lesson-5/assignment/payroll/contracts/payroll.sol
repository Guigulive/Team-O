pragma solidity ^0.4.17;

import './Ownable.sol';
import './SafeMath.sol';
 
contract Payroll is Ownable{
    
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    //总工资
    uint totalSalary;
    //总员工数
    unit totalEmployee;

    //员工列表
    address[] employeeList;

    mapping(address => Employee) public employees;

    //验证地址存在
    modifier employeeExist(address employeeId) {
        Employee  employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    //验证地址不存在
    modifier employeeNotExist(address employeeId){
        Employee employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payments =  now.sub(employee.lastPayday)
        .div(payDuration)
        .mul(employee.salary);
        employee.id.transfer(payments);
    }

    function checkEmployee(uint index) returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId){
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
    }

    function removeEmployee(address employeeId) onlyOwner  employeeExist(employeeId) {
        Employee memory employee= employees[employeeId];

        uint lastIndex = employeeList.length.sub(1);
        employeeList[employee.index] = employeeList[lastIndex];
        employeeList.length = lastIndex;

        delete employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee);
        totalEmployee = totalEmployee.sub(1);

    }

    function updateEmployee(address employeeId, uint salary)
            onlyOwner employeeExist(employeeId) {
        Employee memory employee= employees[employeeId];
        totalSalary = totalSalary.add(salary.mul(1 ether)).sub(employee.salary);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
        _partialPaid(employee);
    }

    function addFund()  payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() view returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender){
        Employee storage employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        require(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function changePaymentAddress(address employeeId,address newEmployeeId) onlyOwner employeeExist(employeeId) employeeNotExist(newEmployeeId) {
        addEmployee(newEmployeeId, employees[employeeId].salary / 1 ether);
        removeEmployee(employeeId);

    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;
        runway = calculateRunway();
        
    }
}
