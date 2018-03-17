/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant PAY_DURATION = 10 seconds;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function isOwner() private returns (bool) {
        return owner == msg.sender;
    }

    function _partialPaid(Employee employee) private {
        require(employee.id != 0x0);
        uint payment = employee.salary * (now - employee.lastPayday) / PAY_DURATION;
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            Employee storage tmpEmp = employees[i];
            if (employeeId == tmpEmp.id) {
                return (tmpEmp, i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) public {
        require(isOwner());
        var (_e, i) = _findEmployee(employeeId);
        assert(_e.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        return;
    }

    function removeEmployee(address employeeId) public {
        require(isOwner());
        var (_e, i) = _findEmployee(employeeId);
        assert(_e.id != 0x0);
        delete employees[i];
        employees[i] = employees[employees.length - 1];
        employees.length--;
        return;
    }

    function updateEmployee(address employeeId, uint salary) public {
        require(isOwner());
        var (_e, i) = _findEmployee(employeeId);
        assert(_e.id != 0x0);
        _partialPaid(_e);
        employees[i].salary = salary;
        _e.lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        require(isOwner());
        return address(this).balance;
    }

    function calculateRunway() public returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        if (totalSalary == 0) {
            return 0;
        }
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() private returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (_e, ,) = _findEmployee(msg.sender);
        assert(_e.id != 0x0);
        uint nextPayDay = _e.lastPayday + PAY_DURATION;
        assert(nextPayDay <= now);
        _e.lastPayday = nextPayDay;
        _e.id.transfer(_e.salary);
    }
}
