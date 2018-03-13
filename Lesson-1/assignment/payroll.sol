pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateAddress(address e){
        require(msg.sender == owner);
        employee = e;
        lastPayday = now;
    }
    
    function updateSalary(uint s){
        require(msg.sender == owner);
        salary = s * 1 ether;
    }
    
    function initEmployee(address e, uint s){
        require(msg.sender == owner);
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        employee = e;
        salary = s * 1 ether;
        if (employee != 0x0) {
            uint periodCount =  (now - lastPayday) / payDuration;
            uint payment = salary * periodCount;
            if(payment>0){
                lastPayday = lastPayday + payDuration*periodCount;
                employee.transfer(payment);
            }
        }
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
