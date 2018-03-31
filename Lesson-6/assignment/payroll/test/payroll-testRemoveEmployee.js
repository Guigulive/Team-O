var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {

     const owner = accounts[0]
     const employee = accounts[1]
     const salary = 2;    
	 
     it("测试先增加员工再将该员工移出，在合约为owner的情况下", function () {
		var payroll;
		
		return Payroll.deployed().then(function(instance) {
			
		payroll = instance;
		
		return payroll.addEmployee(employee, salary, { from: owner });
		
		}).then(function() {
			
			return payroll.removeEmployee(employee);
		
		}).then(function() {
			
			return payroll.employees(employee);
			
		}).then(function(employeeInfo){
			console.log(employeeInfo);
			assert.equal(employeeInfo[0], 0, "移除员工失败");
		});
	});


     it("测试移除一个并不存在的员工", function () {
		 
        var payroll;
        return Payroll.deployed().then( function(instance){
			
            payroll = instance;
            
			return payroll.removeEmployee(employee);
        }).then(function() {
            assert(false, "不能成功移出一个不存在的员工");
        }).catch(function(error){
            assert.include(
				error.toString(), 
				"invalid opcode", 
				"不能移出不存在的员工");
        });
     });

}) 