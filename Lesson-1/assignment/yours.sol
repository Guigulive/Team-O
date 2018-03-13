pragma solidity ^0.4.14;

contract Payroll {
    address boss;

    address employee;
    uint salary;

    uint lastPayTime;
    uint payDuration = 30 days;

    function Payroll() public {
        boss = msg.sender;
    }

    function addFund() public payable returns (uint) {
        return address(this).balance;
    }
    function getFund() public returns (uint) {
        return address(this).balance;
    }

    function calculateRunaway() public returns (uint) {
        return address(this).balance / salary;
    }

    function isFundEnough() public returns (bool) {
        return calculateRunaway() > 0;
    }

    function updateEmployee(address e, uint s) public {
        require(boss == msg.sender);
        if (employee != 0x0) {
            pay(now - lastPayTime);
        } 
        employee = e;
        salary = s;
        lastPayTime = now;
    }

    function updateSalary(uint s) public {
        pay(now - lastPayTime);
        salary = s;
        lastPayTime = now;
    }

    function pay(uint workDuration) public {
        require(boss == msg.sender);
        uint payment = salary * workDuration / payDuration;
        require(getFund() >= payment);
        employee.transfer(payment);
    }

    function getPaid() {
        require(employee == msg.sender);

        uint nextPayTime = lastPayTime + payDuration;
        require(nextPayTime < now);

        lastPayTime = nextPayTime;
        pay(payDuration);
    }

}