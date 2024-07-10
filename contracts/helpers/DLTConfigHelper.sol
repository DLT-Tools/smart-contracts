// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IDLTConfigHelper } from '../interfaces/IDLTConfigHelper.sol';

/// @title DLTBase
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
abstract contract DLTConfigHelper is IDLTConfigHelper {
    // Properties

    address public dltConfig;

    // Events

    event DLTConfigChanged(address indexed oldAddress, address indexed newAddress);

    // Constructors
    constructor(address dltConfig_) {
        dltConfig = dltConfig_;
    }

    // Methods

    function setDLTConfig(address dltConfig_) public virtual {
        emit DLTConfigChanged(dltConfig, dltConfig_);
        dltConfig = dltConfig_;
    }
}
