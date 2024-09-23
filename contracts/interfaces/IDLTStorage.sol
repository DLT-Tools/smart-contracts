// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

/// @title IDLTStorage
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTStorage {
    function getLogicAddress() external view returns (address);
}
