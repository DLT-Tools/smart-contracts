// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

/// @title IDLTLogic
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTLogic {
    function getStorageAddress() external view returns (address);
}
