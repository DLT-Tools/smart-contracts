// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { Pausable } from '@openzeppelin/contracts/utils/Pausable.sol';
import { PAUSER_ROLE } from '../common/Roles.sol';
import { DLTAccessControl } from '../access/DLTAccessControl.sol';
import { IDLTRoleManager } from '../interfaces/IDLTRoleManager.sol';
import { IDLTPausable } from '../interfaces/IDLTPausable.sol';

/// @title DLTPausable
/// @author DLT-Tools Team
/// @dev Base smart contract for DLT, providing pausability.
/// @custom:security-contact support@beruwa.la
abstract contract DLTPausable is IDLTPausable, Pausable, DLTAccessControl {
    constructor(address dltConfig_) DLTAccessControl(dltConfig_) {}

    /// @notice Pause the contract, halting certain functions.
    /// @dev Requires PAUSER_ROLE.
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
        emit Paused(msg.sender);
    }

    /// @notice Unpause the contract.
    /// @dev Requires PAUSER_ROLE.
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
        emit Unpaused(msg.sender);
    }
}
