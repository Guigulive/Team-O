var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

contract('Test_Payroll_addEmployee', function(accounts) {

    const owner = accounts[0];
    const notOwner = accounts[1];
    const employee_1 = accounts[1];
    const salary_1 = 1;
    const employee_2 = accounts[2];
    const salary_2 = 1;

    it("测试owner添加新用户employee_1：添加地址、薪水应符合预期 ", function() {
        return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(employee_1, salary_1, {from: owner});
        }).then(function() {
        employeeAdded = payrollInstance.employees.call(employee_1);
        return employeeAdded;
        }).then(function(employeeAdded) {
        assert(employeeAdded[0] == employee_1 &&
            employeeAdded[1] == web3.toWei(salary_1,'ether'), "添加信息不符合预期");
        });
    });


    it("测试非owner添加另一用户employee_2：预期应造成异常", function() {
        return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(employee_2, salary_2, {from: notOwner});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
        });


    it("测试owner重复添加已有一用户employee_1：预期应造成异常", function() {
        return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(employee_1, salary_1, {from: owner});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
        });        

    
});
