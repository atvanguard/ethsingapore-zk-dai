pragma solidity ^0.4.18;

import "../KyberNetworkProxy.sol";


contract SwapEtherToToken {
    event Swap(address indexed sender, ERC20 destToken, uint amount);

    KyberNetworkProxy public proxy;
    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    //@dev Contract contstructor
    //@param _proxy KyberNetworkProxy contract address
    function SwapEtherToToken(KyberNetworkProxy _proxy) public {
        proxy = _proxy;
    }

    //@dev Swap the user's ETH to ERC20 token
    //@param token destination token contract address
    //@param destAddress address to send swapped tokens to
    function execSwap(ERC20 token, address destAddress) public payable {
        uint minConversionRate;

        // Get the minimum conversion rate
        (minConversionRate,) = proxy.getExpectedRate(ETH_TOKEN_ADDRESS, token, msg.value);

        // Swap the ETH to ERC20 token
        uint destAmount = proxy.swapEtherToToken.value(msg.value)(token, minConversionRate);

        // Send the swapped tokens to the destination address
        require(token.transfer(destAddress, destAmount));

        // Log the event
        Swap(msg.sender, token, destAmount);
    }
}
