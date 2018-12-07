pragma solidity ^0.4.25;

import "./kyber/ERC20Interface.sol";
import "./kyber/KyberNetworkProxy.sol";

contract SecretNote {

  // ERC20 internal DAI_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
  ERC20 DAI_TOKEN_ADDRESS;
  KyberNetworkProxy kyberProxy;

  constructor(address _kyberNetworkProxy, address daiTokenAddress) {
    DAI_TOKEN_ADDRESS = ERC20(daiTokenAddress);
    kyberProxy = KyberNetworkProxy(_kyberNetworkProxy);
  }

  enum State {Invalid, Created, Spent}
  mapping(bytes32 => State) public notes; // mapping of hash of the note to state

  function createNote(ERC20 srcToken, uint srcQty) public {
    // Check that the token transferFrom has succeeded
    require(srcToken.transferFrom(msg.sender, address(this), srcQty));

    // swap srcToken tokens with dai
    uint swappedAmount = kyberSwap(srcToken, srcQty);

    // create secret note @todo nonce
    bytes32 noteHash = sha256(bytes32(msg.sender), bytes32(swappedAmount));
    notes[noteHash] = State.Created;
    emit NoteCreated(noteHash);
  }
  event NoteCreated(bytes32 noteId);

  function kyberSwap(ERC20 srcToken, uint srcQty) internal returns(uint) {
    // Get the minimum conversion rate
    uint minConversionRate;
    (minConversionRate,) = kyberProxy.getExpectedRate(srcToken, DAI_TOKEN_ADDRESS, srcQty);

    kyberProxy.trade(
      srcToken,
      srcQty,
      DAI_TOKEN_ADDRESS, // dest,
      address(this), // destAddress address to send tokens to
      1000000000, // maxDestAmount??
      minConversionRate, // check
      0
    );

    return srcQty * minConversionRate;
  }
}