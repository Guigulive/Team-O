pragma solidity ^0.4.14;


contract Payroll {
    uint constant PAY_DURATION = 10 seconds;
    address owner;
    uint salary;
    address employee;
    uint lastPayday;
    function hasEnoughFund() private returns (bool) {
        return calculateRunway() > 0;
    }

    function calculateRunway() private returns (uint) {
        return (address(this).balance) / salary;
    }

    function Payroll() payable public {
        owner = msg.sender;
    }
    function payLast() private {
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / PAY_DURATION;
            employee.transfer(payment);
        }
    }
    function updateEmployee(address e) public {
        require(msg.sender == owner);
        payLast();
        employee = e;
        lastPayday = block.timestamp;
    }
    function updateSalary(uint s) public {
        require(msg.sender == owner);
        payLast();
        salary = s * 1 ether;
    }
    function getPaid()  public {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + PAY_DURATION;
        assert(nextPayday < block.timestamp);
        lastPayday = nextPayday;
        return employee.transfer(salary);
    }

    function addFund() payable public returns (uint) {
        require(msg.sender == owner);
        return address(this).balance;
    }
}
