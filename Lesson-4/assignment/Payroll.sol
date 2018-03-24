pragma solidity ^0.4.4;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address => Employee) public employees;

    function Payroll() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    /* 新增modifier */
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    /* 员工不能修改合约的支付地址，只能修改自己接收salary的地址 */
    function changePaymentAddress(address newId) employeeNotExist(newId) employeeExist(msg.sender) public {
        var employee = employees[msg.sender];
        require(employee.id == msg.sender);
        require(newId != 0x0);
        uint money = employees[employee.id].salary;
        uint payDay = employees[employee.id].lastPayday;
        delete employees[employee.id];
        employees[newId] = Employee(newId, money, payDay);
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment);

    }

    /* 增加modifier employeeNotExist进行校验 */
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) public {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary*1 ether, now);
        totalSalary += salary * 1 ether;
    }

    /* remove */
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public  {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }
    /* get employee address */
    function getEmployee(address employeeId) public returns (address) {
        var employee = employees[employeeId];
        return (employee.id);
    }

    /* check employee address */
    function checkEmployee(address employeeId) public returns (bool) {
        var employee = employees[employeeId];
        return (employee.id != 0x0);
    }

    /* 修改 */
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId)  public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function getBalance() public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }



    function getPaid() employeeExist(msg.sender) public {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
