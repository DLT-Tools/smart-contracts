// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

/// @title IDLTRoleManager
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTRoleManager {
    // General methods

    function pause() external;

    function unpause() external;

    // Roles methods
    function addRole(bytes32 roleHash, string memory roleCode, string memory roleDescription) external;

    function removeRoleByCode(string memory roleCode) external;

    function removeRole(bytes32 roleHash) external;

    function existsRoleByCode(string memory roleCode) external view returns (bool);

    function existsRole(bytes32 roleHash) external view returns (bool);

    function checkRole(bytes32 roleHash, address user) external view;

    // Users methods

    function getNumUsers() external view returns (uint256);

    function getAllUsers() external view returns (address[] memory);

    function getAllUsersRange(uint256 start, uint256 maxSize) external view returns (address[] memory);

    function getUsersOfByCode(string memory roleCode) external view returns (address[] memory);

    function getUsersOf(bytes32 roleHash) external view returns (address[] memory);

    function hasRoleByCode(string memory roleCode, address user) external view returns (bool);

    function hasRole(bytes32 roleHash, address user) external view returns (bool);

    function grantRoleByCode(string memory roleCode, address user) external;

    function grantRole(bytes32 roleHash, address user) external;

    function setupRoleByCode(string memory roleCode, address user) external;

    function setupRole(bytes32 roleHash, address user) external;

    function revokeRoleByCode(string memory roleCode, address user) external;

    function revokeRole(bytes32 roleHash, address user) external;

    function renounceRoleByCode(string memory roleCode, address callerConfirmation) external;

    function renounceRole(bytes32 roleHash, address callerConfirmation) external;

    function revokeAllRoles(address user) external;

    function getRolesOf(address user) external view returns (bytes32[] memory);
}
