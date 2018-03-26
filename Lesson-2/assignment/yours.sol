pragma solidity ^0.4.14;

contract Payroll {
    //创建员工的类
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    //calculateRunway2的storage变量
    uint totalSalary2 = 0;

    address owner;
    //创建员工类的空数组名为employees
    Employee[] employees;
    

    //构造函数确定合约创建人
    function Payroll() public {
        owner = msg.sender;
    }
    
    //支付未结算的部分工资
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    //检索列表中是否已存在某个员工的记录，返回实例和其索引
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    //增加一个员工类的实例到数组中
    function addEmployee(address employeeId, uint salary) public {
        //约束增加员工信息的权限
        require(msg.sender == owner);
        //调用检索已存在档案，返回实例和其索引(丢弃数据)
        var (employee, index) = _findEmployee(employeeId);
        //若已存在的就revert
        assert(employee.id == 0x0);
        //新档案实例添加到数组
        employees.push(Employee(employeeId, (salary * 1 ether), now));
        
        //calculateRunway2的需求
        totalSalary2 = totalSalary2 + (salary * 1 ether);
    }
    
    //从数组中删除一个员工档案
    function removeEmployee(address employeeId) public {
        //约束删除员工信息的权限
        require(msg.sender == owner);
        //调用检索已存在档案，返回实例和其索引
        var (employee, index) = _findEmployee(employeeId);
        //确定是已存在的档案
        assert(employee.id != 0x0);
        //结算剩余工资
        _partialPaid(employee);

        //calculateRunway2的需求
        totalSalary2 = totalSalary2 - employee.salary;
        
        //清空结果索引的员工档案        
        delete employees[index];
        //将数组最后一个档案替换
        employees[index] = employees[employees.length - 1];
        //裁剪数组长度抹除最后一位
        employees.length -= 1;
    }
    
    
    function updateEmployee(address employeeId, uint salary) public {
        //约束删除员工信息的权限
        require(msg.sender == owner);
        //调用检索已存在档案，返回实例和其索引
        var (employee, index) = _findEmployee(employeeId);
        //确定是已存在的档案
        assert(employee.id != 0x0);
        //在调整工资前结算前期剩余工资
        _partialPaid(employee);
        
        //calculateRunway2的需求
        totalSalary2 = totalSalary2 - employee.salary + (salary * 1 ether);
        
        //更新员工数组内对应档案数据
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    

    function addFund() payable public returns (uint) {
        return this.balance;
    }
    

    function calculateRunway() public returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
        //return totalSalary;
    }

    
    function calculateRunway2() public returns (uint) {
        require(totalSalary2 != 0);
        return this.balance / totalSalary2;
        //return totalSalary2;
    }
    
    
    function hasEnoughFund() public returns (bool) {
        //return calculateRunway() > 0;
        return calculateRunway2() > 0;
    }
    

    function getPaid() public {
        //调用检索已存在档案，返回实例和其索引，确定
        var (employee, index) = _findEmployee(msg.sender);
        //确认领取薪酬的权限
        assert(employee.id != 0x0);
        //确认是否到领薪日
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        //判断合约内余额是否够支付本次领薪水
        assert(this.balance > employee.salary);
        //领取薪水，更新领薪日期
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
}
