// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Token721 is ERC721 {
    uint256 public nextTokenIdToMint;

    constructor() ERC721("Mock NFT", "MOCK") {}

    function mint() external {
        _mint(msg.sender, nextTokenIdToMint);
        nextTokenIdToMint += 1;
    }
}
