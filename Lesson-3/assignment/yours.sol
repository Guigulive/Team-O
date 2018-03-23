/*作业请提交在这个目录下*/
/* 作业提交
第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
答：详见目录下的png文件
第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
答：增加了changePaymentAddress函数，新增modifier:employeeNotExist，复用了modifier:employeeExist，代码详见以下内容。
第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
contract O
contract A is O     [A O] 
contract B is O     [B O] 
contract C is O     [C O] 
contract K1 is A, B     mro(K1)=[K1] + merge(mro(B), mro(A), [A,B]) = [K1,B,A,O]
contract K2 is A, C     mro(K2)=[K2] + merge(mro(C), mro(A), [A,C]) = [K2,C,A,O]
contract Z is K1, K2    mro(Z)=[Z] + merge(mro(K2), mro(K1), [K2,K1]) = [Z] + merge([K2,C,A,O],[K1,B,A,O], [K2,K1])
                         = [Z, K2] + merge([C, A, O], [K1, B, A, O], [K1]) 
                         = [Z, K2, C] + merge([A, O], [K1, B, A, O], [K1])
                         = [Z, K2, C, K1] + merge([A, O], [B, A, O])
                         = [Z, K2, C, K1, B] + merge([A, O], [A, O])
                         = [Z, K2, C, K1, B, A] + merge([O], [O])
                         = [Z, K2, C, K1, B, A, O]                              
答：contract Z 的继承线为[Z, K2, C, K1, B, A, O]
*/
pragma solidity ^0.4.14;

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
    function changePaymentAddress(address newId) employeeNotExist(newId) employeeExist(msg.sender) {
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
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary*1 ether, now);
    }

    /* remove */
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }
    /* 修改 */
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId)  {
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

    function calculateRunway() returns (uint) {

        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    /*
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        return (employee.salary, employee.lastPayday);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }*/


    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
