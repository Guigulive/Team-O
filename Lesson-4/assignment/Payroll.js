var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("should add a new employee successfully.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[1], 1);
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      exists = !!employee;
      assert.equal(exists, true, "Add employee successfully.");
    });
  });

});
