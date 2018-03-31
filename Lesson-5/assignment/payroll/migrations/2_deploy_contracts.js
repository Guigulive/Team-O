var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");
var SimpleStorage = artifacts.require("./SimpleStorage.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
  deployer.link(Ownable,SafeMath,Payroll);
  deployer.deploy(Payroll);
  deployer.deploy(SimpleStorage);
};