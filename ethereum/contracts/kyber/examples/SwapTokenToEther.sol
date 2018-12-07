pragma solidity ^0.4.18;

import "../KyberNetworkProxy.sol";


contract SwapTokenToEther {
    event Swap(address indexed sender, ERC20 srcToken, uint amount);

    KyberNetworkProxy public proxy;
    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    //@dev Contract contstructor
    //@param _proxy KyberNetworkProxy contract address
    function SwapTokenToEther(KyberNetworkProxy _proxy) public {
        proxy = _proxy;
    }

    //@dev Fallback payable function
    function() public payable { }

    //@dev Swap the user's ERC20 token to ETH
    //@param token source token contract address
    //@param tokenQty amount of source tokens
    //@param destAddress address to send swapped ETH to
    function execSwap(ERC20 token, uint tokenQty, address destAddress) public {
        uint minConversionRate;

        // Check that the token transferFrom has succeeded
        require(token.transferFrom(msg.sender, address(this), tokenQty));

        // Mitigate ERC20 Approve front-running attack, by initially setting
        // allowance to 0
        require(token.approve(address(proxy), 0));

        // Set the spender's token allowance to tokenQty
        require(token.approve(address(proxy), tokenQty));

        // Get the minimum conversion rate
        (minConversionRate,) = proxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, tokenQty);

        // Swap the ERC20 token to ETH
        uint destAmount = proxy.swapTokenToEther(token, tokenQty, minConversionRate);

        // Send the swapped ETH to the destination address
        destAddress.transfer(destAmount);

        // Log the event
        Swap(msg.sender, token, destAmount);
    }
}
