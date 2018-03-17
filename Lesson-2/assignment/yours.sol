/*作业请提交在这个目录下*/
/*
Add Employee 1st:
   transaction cost 
  64228 gas 
   execution cost 
  42956 gas 
  
Add Employee 2nd:
   transaction cost 
  34228 gas 
   execution cost 
  12956 gas 
  
Add Employee 3:
   transaction cost 
  34228 gas 
   execution cost 
  12956 gas 
......
优化后的代码第一次add employee的gas消耗较大，后面9次均较小并且数量上保持一致。上图中省略号省略了后7次add employee的gas消耗。
*/

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    uint salaryCount = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment  = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i<employees.length; i++){
            if (employees[i].id == employeeId)
                return (employees[i],i);
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (e,index)  = _findEmployee(employeeId);
        assert(e.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (e,index)  = _findEmployee(employeeId);
        assert(e.id != 0x0);
        _partialPaid(e);
        totalSalary -= employees[index].salary;
        salaryCount--;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length--;
        return;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        salary *= 1 ether;
        require(msg.sender == owner);
        var (e,index)  = _findEmployee(employeeId);
        assert(e.id != 0x0);
        _partialPaid(e);
        totalSalary += salary - employees[index].salary;
        employees[index].salary = salary;
        e.lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (salaryCount < employees.length){
            for (uint i = salaryCount; i < employees.length; i++){
                totalSalary += employees[i].salary;
            }
            salaryCount = employees.length;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (e,index)  = _findEmployee(msg.sender);
        assert(e.id != 0x0);
        uint nextPayDay = e.lastPayday + payDuration;
        assert(nextPayDay <= now);
        e.lastPayday = nextPayDay;
        e.id.transfer(e.salary);
        
    }
}
