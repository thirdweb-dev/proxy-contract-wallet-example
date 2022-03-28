// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

// Test utils
import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";

// Contracts to test
import {Token20} from "../Token20.sol";
import {Token721} from "../Token721.sol";
import {SmartAccount} from "../SmartAccount.sol";

contract SmartAccountTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    Utilities internal utils;

    // End user
    address internal endUser;

    // Mock token contracts
    Token20 internal token20;
    Token721 internal token721;

    // Proxy-wallet
    SmartAccount internal proxyWallet;

    function setUp() public {
        utils = new Utilities();
        endUser = utils.getNextUserAddress();

        // Deploy mock token contracts
        token20 = new Token20();
        token721 = new Token721();

        // End user creates their proxy wallet
        proxyWallet = new SmartAccount(endUser);
    }

    function testProxyWallet() public {
        uint256 targetNFTTokenId = token721.nextTokenIdToMint();
        uint256 erc20AmountToMint = 5 ether;

        // Initially: proxywallet owns no ERC20 or ERC721 tokens.
        assertEq(token20.balanceOf(address(proxyWallet)), 0);

        // End user mints ERC20 and ERC721 tokens in a single transaction via proxy wallet.
        address[] memory executionTarget = new address[](2);
        executionTarget[0] = address(token20);
        executionTarget[1] = address(token721);

        bytes[] memory executionData = new bytes[](2);
        executionData[0] = abi.encodeCall(Token20.mint, (erc20AmountToMint));
        executionData[1] = abi.encodeCall(Token721.mint, ());

        vm.prank(endUser);
        proxyWallet.executeBatch(executionTarget, executionData);

        // Outcome: proxywallet owns the expected ERC20 or ERC721 tokens.
        assertEq(token20.balanceOf(address(proxyWallet)), erc20AmountToMint);
        assertEq(token721.ownerOf(targetNFTTokenId), address(proxyWallet));
    }

    function testProxyWalletReturnAssets() public {
        uint256 erc20AmountToMint = 5 ether;

        // Initially: end user owns no ERC20 or ERC721 tokens.
        assertEq(token20.balanceOf(address(endUser)), 0);

        // End user mints ERC20 tokens -- tokens are first minted to proxyWallet and returned to user's wallet.
        address[] memory executionTarget = new address[](2);
        executionTarget[0] = address(token20);
        executionTarget[1] = address(token20);

        bytes[] memory executionData = new bytes[](2);
        executionData[0] = abi.encodeCall(token20.mint, (erc20AmountToMint));
        executionData[1] = abi.encodeCall(
            token20.transfer,
            (endUser, erc20AmountToMint)
        );

        vm.prank(endUser);
        proxyWallet.executeBatch(executionTarget, executionData);

        // Outcome: end user owns the expected ERC20 tokens.
        assertEq(token20.balanceOf(address(endUser)), erc20AmountToMint);
    }
}
