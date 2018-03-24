/*作业请提交在这个目录下*/
/*
在老师上课的基础上，我用modifier整合了partial paid这个功能，将在update,remove和changePaymentAddress的过程中重用的逻辑加以整合。
*/
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
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    mapping(address => Employee) public employees;

    modifier employeeExist (address employeeId){
       var employee = employees[employeeId];
        assert(employee.id != 0x0); 
        _;
        
    }
    modifier employeePartialPaid(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0); 
        _partialPaid(employee);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment  = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner{
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary.add(salary * 1 ether);
    }
    
    function changePaymentAddress(address preEmployeeId, address newEmployeeId)employeePartialPaid(preEmployeeId){
        var employee = employees[preEmployeeId];
        employee.id = newEmployeeId;
        employees[newEmployeeId] = employee;
        delete employees[preEmployeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeePartialPaid(employeeId){
        
        salary *= 1 ether;
        totalSalary.add(salary.sub(employees[employeeId].salary));
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
    }
    
    function removeEmployee(address  employeeId) onlyOwner employeePartialPaid(employeeId){
        totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        
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
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay <= now);
        employees[msg.sender].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
        
    }
}
