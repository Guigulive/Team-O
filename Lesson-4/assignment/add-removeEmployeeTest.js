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

  it("addEmployee repeatedly", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId1: ",accounts[1]);
      return payrollInstance.addEmployee(accounts[1], 10, {from: accounts[0]});
    }).then(function() {assert(false,"addEmployee repeatedly");},
        function() {assert(true);});
  });

  it("addEmployee with different owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId1: ",accounts[3]);
      return payrollInstance.addEmployee(accounts[3], 10, {from: accounts[2]});
    }).then(function() {assert(false,"no exception");},
        function() {assert(true);});
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

  it("removeEmployee repeatedly.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId3: ",accounts[1]);
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(function() {assert(false,"removeEmployee repeatedly");},
        function() {assert(true);});
  });

  it("removeEmployee with different owner.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("employeeId3: ",accounts[3]);
      return payrollInstance.addEmployee(accounts[3], 10, {from: accounts[0]});
    }).then(function() {
      console.log("employeeId4: ",accounts[3]);
      return payrollInstance.removeEmployee(accounts[3], {from: accounts[4]});
    }).then(function() {
      return payrollInstance.checkEmployee.call(accounts[3]);
    }).then(function() {assert(false,"no exception");},
        function() {assert(true);});
  });

});
