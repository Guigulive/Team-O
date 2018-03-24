var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  it(" add employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(function() {
      return PayrollInstance.employees.call(accounts[1]);
    }).then(function(newEmployee) {
      assert.equal(newEmployee[1], web3.toWei(1), "wrong salary.");
      assert.equal(newEmployee[0], accounts[1], 'wrong address');
      return PayrollInstance;
    }).then(function() {
      return PayrollInstance.getTotalSalary.call();
    }).then(function(TotalSalary) {
      //console.log('Total salary: ', TotalSalary);
      assert.equal(TotalSalary, web3.toWei(1), "wrong totalsalary");
    });
  });

  it(" add fund => calculate runway", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addFund({from: accounts[0], value: 2000000000000000000});
    }).then(function() {
      return PayrollInstance.calculateRunway.call();
    }).then(function(Runway) {
      //console.log("Runway: ", Runway);
      assert.equal(Runway, 2, "wrong runway.");
    }).then(function() {
      return PayrollInstance.hasEnoughFund.call();
    }).then(function(If_Enough) {
      assert.equal(If_Enough, 1, "wrong fund estimation.")
    });
  });

  it(" remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(function() {
      return PayrollInstance.employees.call(accounts[1]);
    }).then(function(newEmployee) {
      assert.equal(newEmployee[0], "0x0000000000000000000000000000000000000000", "failed removal.");
    });
  });

});









