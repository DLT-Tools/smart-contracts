// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IDLTConfig } from '../../interfaces/privateDir/IDLTConfig.sol';
import { SetConfig } from '../../models/privateDir/SetConfig.sol';

/// @title DLTBase
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
contract DLTConfig is IDLTConfig {
    // Properties
    SetConfig private _setConfig;

    // Methods

    function getDLTRoleManager() external view returns (address) {
        require(_setConfig.dltRoleManager != address(0), 'DLTConfig: DLTRoleManager contract address is not defined!');
        return _setConfig.dltRoleManager;
    }

    function getDLTKYCDataLogic() external view returns (address) {
        require(_setConfig.dltKYCDataLogic != address(0), 'DLTConfig: DLTKYCDataLogic contract address is not defined!');
        return _setConfig.dltKYCDataLogic;
    }

    function getDLTKYCDataStorage() external view returns (address) {
        require(_setConfig.dltKYCDataStorage != address(0), 'DLTConfig: DLTKYCDataStorage contract address is not defined!');
        return _setConfig.dltKYCDataStorage;
    }

    function set(SetConfig calldata setConfig_) external {
        // DLTRoleManager
        if (_setConfig.dltRoleManager != setConfig_.dltRoleManager) {
            emit DLTRoleManagerChanged(_setConfig.dltRoleManager, setConfig_.dltRoleManager);
        }
        // DLTKYCDataLogic
        if (_setConfig.dltKYCDataLogic != setConfig_.dltKYCDataLogic) {
            emit DLTKYCDataLogicChanged(_setConfig.dltKYCDataLogic, setConfig_.dltKYCDataLogic);
        }
        // DLTKYCDataStorage
        if (_setConfig.dltKYCDataStorage != setConfig_.dltKYCDataStorage) {
            emit DLTKYCDataStorageChanged(_setConfig.dltKYCDataStorage, setConfig_.dltKYCDataStorage);
        }
        _setConfig = setConfig_;
    }
}
