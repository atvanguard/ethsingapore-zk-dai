pragma solidity ^0.4.25;

import "./kyber/ERC20Interface.sol";

contract SecretNote {
  enum State {Invalid, Created, Spent}
  mapping(bytes32 => State) public notes; // mapping of hash of the note to state
  // hard code for DAI
  ERC20 constant internal DAI_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

//   function createNote(ERC20 srcToken, uint srcQty, amount, nonce) {
//     // Check that the token transferFrom has succeeded
//     require(srcToken.transferFrom(msg.sender, address(this), srcQty));

//     kyberSwap
//     // - swapFromErc20Tkn.transferFrom(msg.sender, this, amount);
//     - KyberSwap swapFromErc20Tkn with Dai;
//     - add note = H(msg.sender, daiValue, nonce) to notes mapping;
//         - notes[H(msg.sender, daiValue, nonce)] = State.Created;
// }

}