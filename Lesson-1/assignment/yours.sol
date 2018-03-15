pragma solidity ^0.4.14;

contract Payroll {
    
    address owner;
    uint salary;//salary viable
    uint payment;
    address employeeAddress;//address viable
    uint constant payDuration = 10 seconds;//as 30 days
    uint lastPayday = now;
    uint lastCalcday = now;
    
    //define contract owner when the contract created
    function Payroll() {
        owner = msg.sender;
    }
    
    function checkTimer() returns(uint) {
        return lastCalcday; 
    }
    
    function updateEmployee (address _employeeAddress, uint _salary) {
        //only the owner has the right to set salary
        //(keep stupid code before lesson 2)
        if(msg.sender != owner){ 
            revert();
        }
        
        salary = _salary * 1 ether;
        
        //calculate payment
        if (_employeeAddress != 0x0) {
            //owner can calculate the payment 
            payment = payment + (salary * (now - lastCalcday) / payDuration);
            //but can not make the transfer, commented, let employees themself
            //employeeAddress.transfer(payment); 
            
            //reset calculation timer
            lastCalcday = now;
        }
        
        employeeAddress = _employeeAddress;

    }
    
    
    //return the balance of current contract
    function addFund() payable returns (uint) {
        return this.balance;
    }

    //return salary afford times
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    //check affordability
    function hasEnoughFund() returns (bool) {
        return this.balance > payment;
    }

    //check payment
    function paymentCount() returns (uint) {
        return payment;
    }

    //employee get his own payment
    function getPaid() payable {

        //reset the withdraw timer
        uint nextPayday = lastPayday + payDuration;
        
        if (nextPayday > now){
            revert();
        }
        
        lastPayday = nextPayday;
        
        if(msg.sender != employeeAddress) {
            revert();
        }
        
        //withdraw all the payment calculated
        employeeAddress.transfer(payment);
        payment = 0;
    }
}