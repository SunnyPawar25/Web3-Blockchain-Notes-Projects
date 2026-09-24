// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title BasicStorage
/// @notice Minimal Week 1 contract for learning deployment and state changes.
contract BasicStorage {
    uint256 private storedValue;

    event ValueChanged(address indexed caller, uint256 newValue);

    function setValue(uint256 newValue) external {
        storedValue = newValue;
        emit ValueChanged(msg.sender, newValue);
    }

    function getValue() external view returns (uint256) {
        return storedValue;
    }
}
