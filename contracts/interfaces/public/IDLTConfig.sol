// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { SetConfig } from '../../models/public/SetConfig.sol';

/// @title IDLTConfig
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTConfig {
    // Events

    event DLTCompanySharesChanged(address indexed oldAddress, address indexed newAddress);
    event DLTBlacklistLogicChanged(address indexed oldAddress, address indexed newAddress);
    event DLTBlacklistStorageChanged(address indexed oldAddress, address indexed newAddress);
    event DLTRoleManagerChanged(address indexed oldAddress, address indexed newAddress);
    event DLTKYCDataLogicChanged(address indexed oldAddress, address indexed newAddress);
    event DLTKYCDataStorageChanged(address indexed oldAddress, address indexed newAddress);

    // Methods

    function getDLTCompanyShares() external view returns (address);

    function getDLTBlacklistLogic() external view returns (address);

    function getDLTBlacklistStorage() external view returns (address);

    function getDLTRoleManager() external view returns (address);

    function getDLTKYCDataLogic() external view returns (address);

    function getDLTKYCDataStorage() external view returns (address);

    function set(SetConfig calldata setConfig) external;
}
