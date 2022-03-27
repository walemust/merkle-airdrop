// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SuperWaleMustapha is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(0x810BdF34895359d1428E36001705e61Fe24Fa70c, 10000000000 * 10**uint256(decimals()));
    }
}
