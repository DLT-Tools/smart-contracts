// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { IDLTAccessControl } from './IDLTAccessControl.sol';

/// @title IDLTPausable
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTPausable is IDLTAccessControl {
    function pause() external;

    function unpause() external;
}
