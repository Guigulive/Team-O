/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ;
    address employee;
    address owner;
    uint constant payDuration = 10 seconds;
    uint lastPayDay = now;

    function Payroll(){
        owner = msg.sender;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function updateEmployee(address e, uint s) public{
        require(msg.sender == owner);

        if(employee != 0x00){
            uint payment = salary * (now - lastPayDay)/payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayDay = now;
    }

    function calculateRunaway()  public returns (uint){
        return this.balance / salary;
    }

    function hasEnoughFund() public returns (bool){
        return calculateRunaway() > 0;
    }

    function getPaid() payable public{
        require(msg.sender == employee);
        require(lastPayDay + payDuration < now);

        //the order of this two statement is curious.
        //modify inner state first, then pay
        lastPayDay = lastPayDay + payDuration;
        employee.transfer(salary);

    }
}
