var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

contract('Test_Payroll_removeEmployee', function(accounts) {

    const owner = accounts[0];
    const notOwner = accounts[1];
    const existEmployee_1 = accounts[1];
    const existSalary_1 = 1;
    const existEmployee_2 = accounts[2];
    const existSalary_2 = 1;
    const existEmployee_3 = accounts[3];
    const existSalary_3 = 1;
    const notExistEmployee = accounts[4];


    it("测试owner移除存在用户existEmployee_1：预期应无法读取原用户信息 ", function() {
        return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(existEmployee_1, existSalary_1, {from: owner});
        }).then(function() {
        payrollInstance.removeEmployee(existEmployee_1, {from: owner});
        return payrollInstance.employees.call(existEmployee_1);
        }).then(function(expectEmpty){
        assert(expectEmpty[0] == 0x0 && expectEmpty[1].toString() == '0', "信息未移除不符合预期");
        });
    });


    it("测试非owner移除存在用户existEmployee_2：预期应造成异常", function() {
        return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(existEmployee_2, existSalary_2, {from: owner});
        }).then(function() {
        return payrollInstance.removeEmployee(existEmployee_2, {from: notOwner});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
    });


    it("测试owner移除不存在用户notExistEmployee：预期应造成异常", function() {
        return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(existEmployee_3, existSalary_3, {from: owner});
        }).then(function() {
        return payrollInstance.removeEmployee(notExistEmployee, {from: owner});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
    });

});
