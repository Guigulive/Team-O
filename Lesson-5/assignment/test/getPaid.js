var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

//本使用测试自然时间过渡法

contract('Test_Payroll_getPaid', function(accounts) {

    const owner = accounts[0];
    const paidEmployee_1 = accounts[1];
    const salary_1 = 1;
    const paidEmployee_2 = accounts[2];
    const salary_2 = 1;
    const paidEmployee_3 = accounts[3];
    const salary_3 = 1;
    const paidEmployee_4 = accounts[4];
    const salary_4 = 1;
    const notPaidEmployee = accounts[9];
    var timepassed;//单位秒


    it("测试不足额情况，员工到期（11秒）领取薪水：预期应造成异常", function() {
        return Payroll.deployed()
        .then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(paidEmployee_4, salary_4, {from: owner});
        }).then(function() {
        timepassed = 11;
        console.log("      等待", timepassed, "秒...");
        return new Promise(function(resolve, reject) {
        setTimeout(resolve, timepassed*1000);});
        }).then(function(){
        return web3.currentProvider.send({jsonrpc: '2.0',method: 'evm_mine'})
        }).then(function(){
        return payrollInstance.getPaid({from: paidEmployee_4});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
    });


    it("测试足额情况，员工到期（11秒）领取薪水：薪水、最后领薪日变动应符合预期", function() {
        return Payroll.deployed()
        .then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addFund({from: owner, value: 10000000000000000000});
        }).then(function() {
        return payrollInstance.addEmployee(paidEmployee_1, salary_1, {from: owner});
        }).then(function() {
        balanceBefore = web3.eth.getBalance(paidEmployee_1);
        timeBefore = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        return balanceBefore,timeBefore;
        }).then(function() {
        timepassed = 11;
        console.log("      等待", timepassed, "秒...");
        return new Promise(function(resolve, reject) {
        setTimeout(resolve, timepassed*1000);});
        }).then(function(){
        return web3.currentProvider.send({jsonrpc: '2.0',method: 'evm_mine'})
        }).then(function(){
        return payrollInstance.getPaid({from: paidEmployee_1});
        }).then(function() {
        balanceAfter = web3.eth.getBalance(paidEmployee_1);
        return balanceAfter;
        }).then(function() {
        stateAfterPaid = payrollInstance.employees.call(paidEmployee_1);
        return stateAfterPaid;
        }).then(function(stateAfterPaid){
        //console.log("      salary增加了：", balanceAfter.toNumber() - balanceBefore.toNumber());
        //console.log("      lastPayDay增加了：", stateAfterPaid[2].toNumber() - timeBefore);
        assert(balanceAfter.toNumber() > balanceBefore.toNumber() && 
            stateAfterPaid[2].toNumber() - timeBefore == 10);})
    });

    it("测试非员工领取薪水：预期应造成异常", function() {
        return Payroll.deployed()
        .then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addFund({from: owner, value: 10000000000000000000});
        }).then(function() {
        return payrollInstance.addEmployee(paidEmployee_2, salary_2, {from: owner});
        }).then(function() {
        timepassed = 11;
        console.log("      等待", timepassed, "秒...");
        return new Promise(function(resolve, reject) {
        setTimeout(resolve, timepassed*1000);});
        }).then(function(){
        return web3.currentProvider.send({jsonrpc: '2.0',method: 'evm_mine'})
        }).then(function(){
        return payrollInstance.getPaid({from: notPaidEmployee});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
    });

    it("测试足额情况，员工未到期（3秒）领取薪水：预期应造成异常", function() {
        return Payroll.deployed()
        .then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addFund({from: owner, value: 10000000000000000000});
        }).then(function() {
        return payrollInstance.addEmployee(paidEmployee_3, salary_3, {from: owner});
        }).then(function() {
        timepassed = 3;
        console.log("      等待", timepassed, "秒...");
        return new Promise(function(resolve, reject) {
        setTimeout(resolve, timepassed*1000);});
        }).then(function(){
        return web3.currentProvider.send({jsonrpc: '2.0',method: 'evm_mine'})
        }).then(function(){
        return payrollInstance.getPaid({from: paidEmployee_3});
        }).then(function() {assert(false,"没有异常 不符合预期");},
                function() {assert(true);});
    });



    /*
    //强制修改时间戳的手段(笔记)
    it("改时间", function() {
        console.log(web3.eth.blockNumber);
        console.log(web3.eth.getBlock(web3.eth.blockNumber).timestamp);
        return Payroll.deployed().then(function() {
            //手动推进params量的时间
            web3.currentProvider.send({
                jsonrpc: "2.0", 
                method: "evm_increaseTime", 
                params: 10, 
                id: []
                });
            //手动增加区块时间
            web3.currentProvider.send({
                jsonrpc: '2.0',
                method: 'evm_increaseTime',
                params: 10,
                id: [],
                })
            //再挖一个区块
            return web3.currentProvider.send({
                jsonrpc: '2.0',
                method: 'evm_mine',
                params: [],
                id: [],
                })
            }).then(function(){
                console.log(web3.eth.blockNumber);
                console.log(web3.eth.getBlock(web3.eth.blockNumber).timestamp);
            });
        });
    */

});