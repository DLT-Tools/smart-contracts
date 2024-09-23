// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { Context } from '@openzeppelin/contracts/utils/Context.sol';
import { IDLTConfig } from '../interfaces/publicDir/IDLTConfig.sol';
import { IDLTRoleManager } from '../interfaces/IDLTRoleManager.sol';
import { DLTConfigHelper } from '../helpers/DLTConfigHelper.sol';
import { IDLTAccessControl } from '../interfaces/IDLTAccessControl.sol';

abstract contract DLTAccessControl is IDLTAccessControl, Context, DLTConfigHelper {
    // Constructors

    constructor(address dltConfig_) DLTConfigHelper(dltConfig_) {}

    // Modifiers

    modifier onlyRole(bytes32 role) {
        address roRoleManager = IDLTConfig(dltConfig).getDLTRoleManager();
        IDLTRoleManager(roRoleManager).checkRole(role, _msgSender());
        _;
    }
}
