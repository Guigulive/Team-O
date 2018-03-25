pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayRoll.sol";

contract TestPayRoll {

  function testItStoresAValue() public {
    PayRoll PayRoll = PayRoll(DeployedAddresses.PayRoll());
    // TODO
    // PayRoll.set(89);

    // uint expected = 89;

    // Assert.equal(PayRoll.get(), expected, "It should store the value 89.");
  }

}
