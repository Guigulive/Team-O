pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable{
    //使uint类型获得Safemath中的4种运算方法
    using SafeMath for uint;
    //创建员工的类
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    //以wei表示的工资数
    uint salary;

    uint constant payDuration = 10 seconds;
    
    //calculateRunway的storage变量
    uint totalSalary = 0;
    uint totalEmployee = 0;

    address[] EmployeeList;

    //创建员工类的mapping名为employees：key=地址,value=Employee结构体
    mapping(address => Employee) public employees;
    
    //创建检测存在用户的modifier
    modifier employee_exist(address employeeId) {
        //用地址参数检索mapping中已存在档案，返回实例到memory
        Employee memory employee = employees[employeeId];
        //若不存在的就revert
        assert(employee.id != 0x0);
        _;
    }

    //创建将ether单位的输入转为wei值的modifier
    modifier ether_to_wei(uint salaryByEther) {
        salary = salaryByEther.mul(1 ether);
        _;
    }

    //支付未结算的部分工资
    function _partialPaid(Employee employee) private {
        uint payment = ((employee.salary).mul(now.sub(employee.lastPayday))).div(payDuration);
        employee.id.transfer(payment);
    }

    //检索列表中是否已存在某个员工的记录，返回其索引
    function _findEmployee(address employeeId) private returns (uint) {
        for (uint i = 0; i < EmployeeList.length; i++) {
            if (EmployeeList[i] == employeeId) {
                return (i);
            }
        }
    }

    function checkEmployee(uint index) public returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = EmployeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }


    //增加一个员工类的实例到mapping中，用2个modifier检测权限和是否已存在
    function addEmployee(address employeeId, uint salaryByEther) public onlyOwner 
        ether_to_wei(salaryByEther) {
        Employee memory employee = employees[employeeId];
        //若已存在的就revert
        assert(employee.id == 0x0);
        //新档案实例添加到mapping
        employees[employeeId] = Employee(employeeId, salary, now);
        //calculateRunway的需求
        totalSalary = totalSalary.add(salary);
        totalEmployee = totalEmployee.add(1);
        EmployeeList.push(employeeId);
    }

    //从数组中删除一个员工档案
    function removeEmployee(address employeeId) public onlyOwner 
        employee_exist(employeeId) {
        Employee memory employee = employees[employeeId];
        _partialPaid(employee);
        //calculateRunway的需求
        totalSalary = totalSalary.sub(employee.salary);
        totalEmployee = totalEmployee.sub(1);
        //删除员工档案        
        delete employees[employeeId];

        var index = _findEmployee(employeeId);
        delete EmployeeList[index];
        EmployeeList[index] = EmployeeList[EmployeeList.length - 1];
        EmployeeList.length -= 1;

    }
    
    //更新员工档案信息
    function updateEmployee(address employeeId, uint salaryByEther) public onlyOwner
        employee_exist(employeeId) ether_to_wei(salaryByEther) {
        Employee memory employee = employees[employeeId];
        //在调整工资前结算前期剩余工资
        _partialPaid(employee);
        //calculateRunway的需求
        totalSalary = totalSalary.sub(employee.salary);
        //更新员工数组内对应档案数据
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(salary);
    }

    //更改员工地址
    function changePaymentAddress(address originalId, address newId) public onlyOwner
        employee_exist(originalId) {
        Employee memory employee = employees[originalId];
        //在更新地址前结算前期剩余工资
        _partialPaid(employee);
        employees[newId] = Employee(newId, employee.salary, now);
        //清除原有记录
        delete employees[originalId];
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public constant returns (uint) {
        require(totalSalary != 0);
        return (this.balance).div(totalSalary);
    }
    
    function hasEnoughFund() public constant returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public 
        employee_exist(msg.sender) {
        Employee memory employee = employees[msg.sender];

        //确认是否到领薪日
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        //判断合约内余额是否够支付本次领薪水
        assert(this.balance > employee.salary);
        //领取薪水，更新领薪日期
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    

    function checkInfo() public constant returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;
        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }

}
