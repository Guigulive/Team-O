/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary;//salary viable
    address staffAddress;//address viable
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    //return the balance of current contract
    function addFund() payable returns (uint) {
        return this.balance;
    }

    //return salary afford times
    function calculateRunway(uint salary) constant public returns (uint) {
        return this.balance / salary;
    }

    //check affordability
    function hasEnoughFund(uint salary) constant public returns (bool) {
        return calculateRunway(salary) > 0;
    }

    //sender get his salary
    function getPaid(address staffAddress, uint salary) public payable {
        if(msg.sender != staffAddress) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        staffAddress.transfer(salary);
    }
}