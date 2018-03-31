var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("add&getEmployee function unit test.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId: ",accounts[1]);
      return payrollInstance.addEmployee(accounts[1], 10, {from: accounts[0]});
    }).then(function() {
      console.log("employeeId: ",accounts[1]);
      return payrollInstance.getEmployee.call(accounts[1]);
    }).then(function(resultaddress) { 
      console.log("resultaddress=",resultaddress);
      assert.equal(resultaddress, 0x0, "Adding employee is not successful.");
    });
  });

});
