// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import {Token20} from "./Token20.sol";
import {Token721} from "./Token721.sol";

// TODO: Add explainer comments

contract TargetScript {
    constructor() {}

    function transferTokens(
        address _erc721Token,
        address _erc20Token,
        uint256 _erc20AmountToMint
    ) external {
        // Mint ERC20 tokens
        Token20(_erc20Token).mint(msg.sender, _erc20AmountToMint);

        // Mint ERC721 NFT
        Token721(_erc721Token).mint(msg.sender);
    }
}
