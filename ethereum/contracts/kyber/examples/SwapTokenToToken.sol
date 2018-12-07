pragma solidity ^0.4.18;

import "../KyberNetworkProxy.sol";


contract SwapTokenToToken {
    event Swap(address indexed sender, ERC20 srcToken, ERC20 destToken, uint amount);

    KyberNetworkProxy public proxy;
    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    //@dev Contract contstructor
    //@param _proxy KyberNetworkProxy contract address
    function SwapTokenToToken(KyberNetworkProxy _proxy) public {
        proxy = _proxy;
    }

    //@dev Swap the user's ERC20 token to another ERC20 token
    //@param srcToken source token contract address
    //@param srcQty amount of source tokens
    //@param destToken destination token contract address
    //@param destAddress address to send swapped tokens to
    function execSwap(ERC20 srcToken, uint srcQty, ERC20 destToken, address destAddress) public {
        uint minConversionRate;

        // Check that the token transferFrom has succeeded
        require(srcToken.transferFrom(msg.sender, address(this), srcQty));

        // Mitigate ERC20 Approve front-running attack, by initially setting
        // allowance to 0
        require(srcToken.approve(address(proxy), 0));

        // Set the spender's token allowance to tokenQty
        require(srcToken.approve(address(proxy), srcQty));

        // Get the minimum conversion rate
        (minConversionRate,) = proxy.getExpectedRate(srcToken, ETH_TOKEN_ADDRESS, srcQty);

        // Swap the ERC20 token to ETH
        uint destAmount = proxy.swapTokenToToken(srcToken, srcQty, destToken, minConversionRate);

        // Send the swapped tokens to the destination address
        require(destToken.transfer(destAddress, destAmount));

        // Log the event
        Swap(msg.sender, srcToken, destToken, destAmount);
    }
}
