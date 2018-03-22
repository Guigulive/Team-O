/**
 * 
 * 作业3:
    C3算法的本质就是Merge，规则如下：
    1. 如果第一个序列的第一个元素，是后续序列的第一个元素，或者不再后续序列中再次出现，则将这个元素合并到最终的方法解析顺序序列中，并从当前操作的全部序列中删除。
    2. 如果不符合，则跳过此元素，查找下一个列表的第一个元素，重复1的判断规则
    
    contract O
    contract A is O
    contract B is O
    contract C is O
    contract K1 is A, B
    contract K2 is A, C
    contract Z is K1, K2


    L(O) := [O]
    
    L(A) := [A] + merge(L(O), [O])  
        = [A, O]
        
    L(B) := [B, O] 
      
    L(C) := [C, O]  
        
    L(K1) := [K1] + merge(L(B), L(A), [B, A])  
        = [K1] + merge([B, O], [A, O], [B, A])  
        = [K1, B] + merge([O], [A, O], [A])  
        = [K1, B, A] + merge([O], [O]) 
        = [K1, B, A, O]
       
    L(K2) := [K2, C, A, O]
       
    L(Z) := [Z] + merge(L(K2), L(K1), [K2, K1])  
       = [Z] + merge([K2, C, A, O], [K1, B, A, O], [K2, K1]) 
       = [Z, K2] + merge([C, A, O], [K1, B, A, O], [K1]) 
       = [Z, K2, C] + merge([A, O], [K1, B, A, O], [K1])
       = [Z, K2, C, K1] + merge([A, O], [B, A, O])
       = [Z, K2, C, K1, B] + merge([A, O], [A, O])
       = [Z, K2, C, K1, B, A] + merge([O], [O])
       = [Z, K2, C, K1, B, A, O]
 * */
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

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId){
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }

    function removeEmployee(address employeeId) onlyOwner  employeeExist(employeeId) {
        Employee memory employee= employees[employeeId];
        delete employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee);
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

    //作业2
    function changePaymentAddress(address employeeId,address newEmployeeId) onlyOwner employeeExist(employeeId) employeeNotExist(newEmployeeId) {
        addEmployee(newEmployeeId, employees[employeeId].salary / 1 ether);
        removeEmployee(employeeId);

    }
}
