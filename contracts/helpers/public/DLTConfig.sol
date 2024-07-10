// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IDLTConfig } from '../../interfaces/public/IDLTConfig.sol';
import { SetConfig } from '../../models/public/SetConfig.sol';

/// @title DLTBase
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
contract DLTConfig is IDLTConfig {
    // Properties
    SetConfig private _setConfig;

    // Methods
    function getDLTCompanyShares() external view returns (address) {
        require(_setConfig.dltCompanyShares != address(0), 'DLTConfig: DLTCompanyShares contract address is not defined!');
        return _setConfig.dltCompanyShares;
    }

    function getDLTBlacklistLogic() external view returns (address) {
        require(_setConfig.dltBlacklistLogic != address(0), 'DLTConfig: DLTBlacklistLogic contract address is not defined!');
        return _setConfig.dltBlacklistLogic;
    }

    function getDLTBlacklistStorage() external view returns (address) {
        require(_setConfig.dltBlacklistStorage != address(0), 'DLTConfig: DLTBlacklistStorage contract address is not defined!');
        return _setConfig.dltBlacklistStorage;
    }

    function getDLTKYCDataLogic() external view returns (address) {
        require(_setConfig.dltKYCDataLogic != address(0), 'DLTConfig: DLTKYCDataLogic contract address is not defined!');
        return _setConfig.dltKYCDataLogic;
    }

    function getDLTKYCDataStorage() external view returns (address) {
        require(_setConfig.dltKYCDataStorage != address(0), 'DLTConfig: DLTKYCDataStorage contract address is not defined!');
        return _setConfig.dltKYCDataStorage;
    }

    function getDLTRoleManager() external view returns (address) {
        require(_setConfig.dltRoleManager != address(0), 'DLTConfig: DLTRoleManager contract address is not defined!');
        return _setConfig.dltRoleManager;
    }

    function set(SetConfig calldata setConfig_) external {
        // DLTCompanyShares
        if (_setConfig.dltCompanyShares != setConfig_.dltCompanyShares) {
            emit DLTCompanySharesChanged(_setConfig.dltCompanyShares, setConfig_.dltCompanyShares);
        }
        // DLTBlacklistLogic
        if (_setConfig.dltBlacklistLogic != setConfig_.dltBlacklistLogic) {
            emit DLTBlacklistLogicChanged(_setConfig.dltBlacklistLogic, setConfig_.dltBlacklistLogic);
        }
        // DLTBlacklistStorage
        if (_setConfig.dltBlacklistStorage != setConfig_.dltBlacklistStorage) {
            emit DLTBlacklistStorageChanged(_setConfig.dltBlacklistStorage, setConfig_.dltBlacklistStorage);
        }
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
