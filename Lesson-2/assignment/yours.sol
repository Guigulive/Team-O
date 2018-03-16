pragma solidity ^0.4.14;

contract Payroll {

    address owner;
    uint constant payDuration = 10 seconds;

    uint totalSalary;


    struct  Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }

    Employee[] employees;

    function _partialPay(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayDay) * payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeID) private returns (Employee, uint){
      for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeID){
                return (employees[i], i);
            }
        }
        // return (0, 0);
    }

    function addEmployee(address employeeID, uint salary){
        require(msg.sender == owner);
        var (employee, index)  = _findEmployee(employeeID);
        assert(employee.id == 0x00);
        employees.push(Employee(employeeID, salary * 1 ether, now));
        totalSalary += salary;
    }


    function removeEmployee(address employeeID){
        require(msg.sender == owner);

        for(uint i = 0; i < employees.length; i++){
            totalSalary -= employees[i].salary;
            delete employees[i];
            employees[i] = employees[employees.length -1];
            employees.length -= 1;

            return;
        }

    }

    function updateEmployee(address employeeID, uint salary){
        require(msg.sender == owner);

        var (e, index) = _findEmployee(employeeID);
        require(e.id != 0x00);

        _partialPay(e);
        totalSalary -= employees[index].salary;
        employees[index].id = employeeID;
        employees[index].salary = salary;
        totalSalary += salary;

    }

    function getPaid() payable public{
        var (e, index) = _findEmployee(msg.sender);
        require(e.id != 0x00);
        require(e.lastPayDay + payDuration < now);

        employees[index].lastPayDay = now;
        e.id.transfer(e.salary);
    }

    function Payroll() public{
        owner = msg.sender;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }



    function calculateRunaway()  public returns (uint){
        // uint totalSalary = 0;
        // for(uint i = 0; i < employees.length; i++){
        //     totalSalary += employees[i].salary;
        // }

        require(totalSalary != 0);

        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool){
        return calculateRunaway() > 0;
    }


}
