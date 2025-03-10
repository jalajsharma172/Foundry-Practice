// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract SecureToken is ERC20 {
    constructor() ERC20("SecureToken", "STK") {
        _mint(msg.sender, 1000 * 10**18); // Mint initial supply
    }
}
