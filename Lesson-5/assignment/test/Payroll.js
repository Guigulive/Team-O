var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("...should store the value 89.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId: ",accounts[0]);
      return payrollInstance.addFund({from: accounts[0], value: 1000});
    }).then(function() {
      return payrollInstance.getBalance.call();
    }).then((result) => { 
      console.log("Balance: ",result.c[0]);
      assert.equal(result.c[0], 1000, "The value 100 was not stored.");
    });
  });

});
