// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.0 <0.9.0;

import "forge-std/Test.sol";
import { ModuleManager, FaucetModule, TooEarly, FailureInSafe } from "../src/FaucetModule.sol";

/**
 * @dev basic test for faucet module
 */
contract FaucetModuleTest is Test {
    using stdStorage for StdStorage;

    FaucetModule public module;

    function setUp() public {
        module = new FaucetModule();
    }

    function testFuzz_faucet(address safe, address recipient) public {
        vm.mockCall(
            address(safe), abi.encodeWithSelector(ModuleManager.execTransactionFromModule.selector), abi.encode(true)
        );

        module.faucet(safe, recipient);
        vm.clearMockedCalls();
    }

    function testRevert_TooEarly(address safe, address recipient, uint256 activateTime) public {
        vm.assume(activateTime > 1);
        vm.warp(activateTime - 1);
        stdstore.target(address(module)).sig("activationTime(address)").with_key(safe).checked_write(activateTime);

        vm.mockCall(
            address(safe), abi.encodeWithSelector(ModuleManager.execTransactionFromModule.selector), abi.encode(true)
        );
        vm.expectRevert(abi.encodeWithSelector(TooEarly.selector, activateTime));
        module.faucet(safe, recipient);
        vm.clearMockedCalls();
    }

    function testRevert_FailureInSafe(address safe, address recipient) public {
        vm.mockCall(
            address(safe), abi.encodeWithSelector(ModuleManager.execTransactionFromModule.selector), abi.encode(false)
        );
        vm.expectRevert(FailureInSafe.selector);
        module.faucet(safe, recipient);
        vm.clearMockedCalls();
    }
}
