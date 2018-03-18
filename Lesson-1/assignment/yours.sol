/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary = 100 wei; // default employee salary
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c; // default employee address
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployeeAddress(address e){
        require(msg.sender == owner);
        
        if (employee != 0x0){
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        lastPayday = now;
    }
    
    function updateEmployeeSalary(uint s){
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        salary = s * 1 wei;
        lastPayday = now;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
