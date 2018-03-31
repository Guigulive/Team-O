var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  const owner = accounts[0];
  const employeeId = accounts[1];
  const salary = 2;

  it("测试添加员工 salary 为2.", function() {
    return Payroll.deployed().then(function(instance) {
		
      payrollInstance = instance;
	  
      return payrollInstance.addEmployee( employeeId, salary, {from: owner});
    }).then(function(){
		
      return payrollInstance.employees(employeeId);
	  
    }).then(function(employee){
      console.log(employee);
      assert.equal(employee[1], web3.toWei(salary, 'ether'), "员工添加失败!");
    });
  });

});
