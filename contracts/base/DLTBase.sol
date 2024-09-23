// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { DLTPausable } from '../security/DLTPausable.sol';
import { DEFAULT_ADMIN_ROLE } from '../common/Roles.sol';
import { IDLTBase } from '../interfaces/IDLTBase.sol';

/// @title DLTBase
/// @author DLT-Tools Team
/// @dev Base smart contract for DLT, providing access control and pausability.
/// @custom:security-contact support@beruwa.la
abstract contract DLTBase is IDLTBase, DLTPausable {
    // Constructors

    constructor(address dltConfig_) DLTPausable(dltConfig_) {}

    // Methods

    function setDLTConfig(address dltConfig_) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        emit DLTConfigChanged(dltConfig, dltConfig_);
        dltConfig = dltConfig_;
    }
}
