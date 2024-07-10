// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { SetConfig } from '../../models/private/SetConfig.sol';

/// @title IDLTConfig
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTConfig {
    // Events

    event DLTRoleManagerChanged(address indexed oldAddress, address indexed newAddress);
    event DLTKYCDataLogicChanged(address indexed oldAddress, address indexed newAddress);
    event DLTKYCDataStorageChanged(address indexed oldAddress, address indexed newAddress);

    // Methods

    function getDLTRoleManager() external view returns (address);

    function getDLTKYCDataLogic() external view returns (address);

    function getDLTKYCDataStorage() external view returns (address);

    function set(SetConfig calldata setConfig) external;
}
