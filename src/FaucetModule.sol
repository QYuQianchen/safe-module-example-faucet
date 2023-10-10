// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;

import { ModuleManager, Enum } from "safe-contracts/contracts/base/ModuleManager.sol";

error TooEarly(uint256 activationTime);
error FailureInSafe();

/**
 * @title A simple faucet module for Safe
 * @author QYuQianchen
 * @notice A faucet module that sends out 0.1 ETH with an interval of minimum 1 hr.
 * Any account can execute a faucet transfer if condition meets, but nothing else.
 * @dev This example is solely for the purpose of showing how a very naive module works.
 * No re-entrancy protection is in place. Do not use in production.
 */
contract FaucetModule {
    mapping(address => uint256) public activationTime; // safe -> activation time
    mapping(address => uint256) public credit; // safe -> distributed balance
    uint256 public constant MIN_INTERVAL = 3600; // one hour in seconds
    uint256 public constant FUND_VALUE = 0.1 ether; // transfer a fixed amount of 0.1 ETH each time

    /**
     * @dev Transfer a fixed amount of ether from a Safe to the recipient.
     * It can be executed every min. 1 hour per Safe.
     * @param safeAddr The address of the safe contract.
     * @param recipient The recipient of funds.
     */
    function faucet(address safeAddr, address recipient) external {
        // check if the activation time has reached
        if (block.timestamp < activationTime[safeAddr]) {
            revert TooEarly(activationTime[safeAddr]);
        }
        // if not, update the activation time
        activationTime[safeAddr] = block.timestamp + MIN_INTERVAL;

        // update the credit of the safe
        credit[safeAddr] += FUND_VALUE;

        // transfer ETH from the targeted Safe
        bool success = ModuleManager(safeAddr).execTransactionFromModule(recipient, FUND_VALUE, "", Enum.Operation.Call);
        if (!success) {
            revert FailureInSafe();
        }
    }
}
