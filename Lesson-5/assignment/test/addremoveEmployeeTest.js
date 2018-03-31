var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("addEmployee function unit test.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId1: ",accounts[1]);
      return payrollInstance.addEmployee(accounts[1], 10, {from: accounts[0]});
    }).then(function() {
      console.log("employeeId2: ",accounts[1]);
      return payrollInstance.checkEmployee.call(accounts[1]);
    }).then(function(resultBool) { 
      assert.equal(resultBool, true, "Adding employee is not successful.");
    });
  });

  it("removeEmployee function unit test.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId3: ",accounts[1]);
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(function() {
      console.log("employeeId4: ",accounts[1]);
      return payrollInstance.checkEmployee.call(accounts[1]);
    }).then(function(resultBool) {
      assert.equal(resultBool, false, "Removing employee is not successful.");
    });
  });

});
