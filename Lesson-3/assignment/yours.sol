pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant PAY_DURATION = 10 seconds;
    address owner;
    mapping(address => Employee) public employees;
    uint totalSalary = 0;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier employeeExist (address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        require(employee.id != 0x0);
        uint payment = employee.salary * (now - employee.lastPayday) / PAY_DURATION;
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private view returns (Employee) {
        return employees[employeeId];
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        var _e = _findEmployee(employeeId);
        assert(_e.id == 0x0);
        uint paySalary = salary * 1 ether;
        totalSalary += paySalary;
        employees[employeeId] = Employee(employeeId, paySalary, now);
        return;
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        var _e = _findEmployee(employeeId);
        totalSalary -= _e.salary;
        delete employees[employeeId];
        return;
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        var _e = _findEmployee(employeeId);
        _partialPaid(_e);
        uint paySalary = salary * 1 ether;
        totalSalary += paySalary;
        totalSalary -= _e.salary;
        _e.salary = paySalary;
        _e.lastPayday = now;
    }

    function changePaymentAddress(address oldEmployeeId, address employeeId) public view onlyOwner employeeExist(oldEmployeeId) {
        var _e = _findEmployee(oldEmployeeId);
        _e.id = employeeId;
    }

    function addFund() payable public onlyOwner returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() private view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var _e = _findEmployee(msg.sender);
        assert(_e.id != 0x0);
        uint nextPayDay = _e.lastPayday + PAY_DURATION;
        assert(nextPayDay <= now);
        _e.lastPayday = nextPayDay;
        _e.id.transfer(_e.salary);
    }
}
