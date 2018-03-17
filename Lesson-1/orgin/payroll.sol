pragma solidity ^0.4.14;
contract Payroll {
    uint salary = 1 ;
    address receiver = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayDay = now;
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunaway()  public returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() public returns (bool){
        return calculateRunaway() > 0;
    }
    
    function getPaid() payable public{
        if(msg.sender != receiver){
            revert();
        }
        
        if(lastPayDay + payDuration > now){
            revert();
        }
        
        //the order of this two statement is curious.
        //modify inner state first, then pay
        lastPayDay = lastPayDay + payDuration;
        receiver.transfer(salary);
        
    }
    
    function setSalary(uint x) public{
        salary = x;
    }
    
    function setReceiver(address x) public{
        receiver = x;
    }
}
