// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token20 is ERC20 {
    constructor() ERC20("Mock token", "MOCK") {}

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }
}
