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
import {TargetScript} from "../TargetScript.sol";
import {PRBProxy} from "../PRBProxy.sol";

contract ProxyWalletTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    Utilities internal utils;

    // End user
    address internal endUser;

    // Mock token contracts
    Token20 internal token20;
    Token721 internal token721;

    // Proxy-wallet + target script to hit
    PRBProxy internal proxyWallet;
    TargetScript internal target;

    function setUp() public {
        utils = new Utilities();
        endUser = utils.getNextUserAddress();

        // Deploy mock token contracts
        token20 = new Token20();
        token721 = new Token721();

        // End user creates their proxy wallet
        vm.prank(endUser);
        proxyWallet = new PRBProxy();

        // User-application deploys target script for end user's proxy wallet to hit
        target = new TargetScript();
    }

    function testProxyWalletTransaction() public {
        console.logAddress(address(proxyWallet));

        uint256 targetNFTTokenId = token721.nextTokenIdToMint();
        uint256 erc20AmountToMint = 5 ether;

        // Initially: end users owns no ERC20 or ERC721 tokens.
        assertEq(token20.balanceOf(endUser), 0);

        // End user mints ERC20 and ERC721 tokens in a single transaction via proxy wallet + target script.
        address executionTarget = address(target);
        bytes memory executionData = abi.encodeCall(
            TargetScript.transferTokens,
            (address(token721), address(token20), erc20AmountToMint)
        );

        vm.prank(endUser);
        proxyWallet.execute(executionTarget, executionData);

        // Outcome: end users owns the expected ERC20 or ERC721 tokens.
        assertEq(token20.balanceOf(endUser), erc20AmountToMint);
        assertEq(token721.ownerOf(targetNFTTokenId), address(endUser));
    }
}
