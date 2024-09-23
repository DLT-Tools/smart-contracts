// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import '@openzeppelin/contracts/utils/Pausable.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';
import { EnumerableSet } from '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import { PAUSER_ROLE_CODE, PAUSER_ROLE, PAUSER_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { USER_MANAGER_ROLE_CODE, USER_MANAGER_ROLE, USER_MANAGER_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { BLACKLIST_MANAGER_ROLE_CODE, BLACKLIST_MANAGER_ROLE, BLACKLIST_MANAGER_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { REALESTATE_MANAGER_ROLE_CODE, REALESTATE_MANAGER_ROLE, REALESTATE_MANAGER_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { DEFAULT_ADMIN_ROLE_CODE, DEFAULT_ADMIN_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { MINTER_ROLE_CODE, MINTER_ROLE, MINTER_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { TREASURER_ROLE_CODE, TREASURER_ROLE, TREASURER_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { KYC_MANAGER_ROLE_CODE, KYC_MANAGER_ROLE, KYC_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { KYC_BACKEND_ROLE_CODE, KYC_BACKEND_ROLE, KYC_BACKEND_ROLE_DESCRIPTION } from '../common/Roles.sol';
import { RoleInfo } from '../models/RoleInfo.sol';
import { IDLTRoleManager } from '../interfaces/IDLTRoleManager.sol';
import { DLTConfigHelper } from '../helpers/DLTConfigHelper.sol';
import { DLTValidations } from '../lib/DLTValidations.sol';

/// @title DLTRoleManager
/// @author DLT-Tools Team
/// @notice This contract allows for the management of user roles.
/// @dev Roles are represented as bytes32 and each role is associated with a set of addresses (managers).
/// @custom:security-contact support@beruwa.la
contract DLTRoleManager is Pausable, AccessControl, DLTConfigHelper, IDLTRoleManager {
    // Usings

    using EnumerableSet for EnumerableSet.Bytes32Set;
    using EnumerableSet for EnumerableSet.AddressSet;

    // Properties

    // key = role hash, value - users
    mapping(bytes32 => EnumerableSet.AddressSet) private _roleUsers;
    // key = user wallet address, value - role list where is user assigned
    mapping(address => EnumerableSet.Bytes32Set) private _userRoles;
    // key = role hash, value = role info
    mapping(bytes32 => RoleInfo) private _roleInfos;
    address private _cannotRevokedByOther;
    EnumerableSet.Bytes32Set private _rolesHashs;
    EnumerableSet.AddressSet private _allUsers;

    // Constructors

    constructor(address dltConfig_) DLTConfigHelper(dltConfig_) {
        _setUserManagerRoleAndAdmin();
        _cannotRevokedByOther = msg.sender;

        addRole(PAUSER_ROLE, PAUSER_ROLE_CODE, PAUSER_ROLE_DESCRIPTION);
        super._setRoleAdmin(PAUSER_ROLE, USER_MANAGER_ROLE);
        addRole(BLACKLIST_MANAGER_ROLE, BLACKLIST_MANAGER_ROLE_CODE, BLACKLIST_MANAGER_ROLE_DESCRIPTION);
        super._setRoleAdmin(BLACKLIST_MANAGER_ROLE, USER_MANAGER_ROLE);
        addRole(REALESTATE_MANAGER_ROLE, REALESTATE_MANAGER_ROLE_CODE, REALESTATE_MANAGER_ROLE_DESCRIPTION);
        super._setRoleAdmin(REALESTATE_MANAGER_ROLE, USER_MANAGER_ROLE);
        addRole(MINTER_ROLE, MINTER_ROLE_CODE, MINTER_ROLE_DESCRIPTION);
        super._setRoleAdmin(MINTER_ROLE, USER_MANAGER_ROLE);
        addRole(TREASURER_ROLE, TREASURER_ROLE_CODE, TREASURER_ROLE_DESCRIPTION);
        super._setRoleAdmin(TREASURER_ROLE, USER_MANAGER_ROLE);
        addRole(KYC_MANAGER_ROLE, KYC_MANAGER_ROLE_CODE, KYC_ROLE_DESCRIPTION);
        super._setRoleAdmin(KYC_MANAGER_ROLE, USER_MANAGER_ROLE);
        addRole(KYC_BACKEND_ROLE, KYC_BACKEND_ROLE_CODE, KYC_BACKEND_ROLE_DESCRIPTION);
        super._setRoleAdmin(KYC_BACKEND_ROLE, USER_MANAGER_ROLE);

        grantRole(PAUSER_ROLE, msg.sender);
        grantRole(BLACKLIST_MANAGER_ROLE, msg.sender);
        grantRole(REALESTATE_MANAGER_ROLE, msg.sender);
        grantRole(MINTER_ROLE, msg.sender);
        grantRole(TREASURER_ROLE, msg.sender);
        grantRole(KYC_MANAGER_ROLE, msg.sender);
        grantRole(KYC_BACKEND_ROLE, msg.sender);
    }

    // Pause implementation

    /// @notice Pause the contract, halting certain functions.
    /// @dev Requires PAUSER_ROLE.
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
        emit Paused(msg.sender);
    }

    /// @notice Unpause the contract.
    /// @dev Requires PAUSER_ROLE.
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
        emit Unpaused(msg.sender);
    }

    // Modifiers
    modifier validRole(bytes32 roleHash_) {
        require(existsRole(roleHash_), 'DLTRoleManager: Role not exists');
        _;
    }

    modifier validHasRole(address user_, bytes32 roleHash_) {
        require(hasRole(roleHash_, user_), 'DLTRoleManager: User not has the role');
        _;
    }

    modifier validAllowRevoke(address user_) {
        require(_cannotRevokedByOther != user_, 'DLTRoleManager: User not allowed to revoke role by other');
        _;
    }

    // General methods
    function _stringToHash(string memory string_) internal pure returns (bytes32) {
        return keccak256(bytes(string_));
    }

    function _setUserManagerRoleAndAdmin() internal {
        _rolesHashs.add(DEFAULT_ADMIN_ROLE);
        _roleInfos[DEFAULT_ADMIN_ROLE] = RoleInfo(DEFAULT_ADMIN_ROLE, DEFAULT_ADMIN_ROLE_CODE, DEFAULT_ADMIN_ROLE_DESCRIPTION);

        _rolesHashs.add(USER_MANAGER_ROLE);
        _roleInfos[USER_MANAGER_ROLE] = RoleInfo(USER_MANAGER_ROLE, USER_MANAGER_ROLE_CODE, USER_MANAGER_ROLE_DESCRIPTION);
        super._setRoleAdmin(USER_MANAGER_ROLE, DEFAULT_ADMIN_ROLE);

        super._grantRole(USER_MANAGER_ROLE, msg.sender);
        _roleUsers[USER_MANAGER_ROLE].add(msg.sender);
        _userRoles[msg.sender].add(USER_MANAGER_ROLE);

        super._grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _roleUsers[DEFAULT_ADMIN_ROLE].add(msg.sender);
        _userRoles[msg.sender].add(DEFAULT_ADMIN_ROLE);
    }

    // Roles methods
    function addRole(
        bytes32 roleHash_,
        string memory roleCode_,
        string memory roleDescription_
    ) public onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        DLTValidations.validString(roleDescription_, 'roleDescription_');
        require(!existsRole(roleHash_), 'DLTRoleManager: Role already exists');
        _rolesHashs.add(roleHash_);
        _roleInfos[roleHash_] = RoleInfo(roleHash_, roleCode_, roleDescription_);
    }

    function removeRoleByCode(string memory roleCode_) public onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        bytes32 roleHash = _stringToHash(roleCode_);
        removeRole(roleHash);
    }

    function removeRole(bytes32 roleHash_) public onlyRole(USER_MANAGER_ROLE) validRole(roleHash_) {
        _rolesHashs.remove(roleHash_);
        delete _roleInfos[roleHash_];
    }

    function existsRoleByCode(string memory roleCode_) public view returns (bool) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        bytes32 roleHash = _stringToHash(roleCode_);
        return existsRole(roleHash);
    }

    function existsRole(bytes32 roleHash_) public view returns (bool) {
        return _rolesHashs.contains(roleHash_);
    }

    function checkRole(bytes32 roleHash_, address user_) public view {
        DLTValidations.validAddress(user_, 'user_');
        _checkRole(roleHash_, user_);
    }

    // Users methods
    function _refreshAllUsers(address user_) internal {
        if (_userRoles[user_].length() == 0 && _allUsers.contains(user_)) {
            _allUsers.remove(user_);
        } else if (_userRoles[user_].length() > 0 && !_allUsers.contains(user_)) {
            _allUsers.add(user_);
        }
    }

    function getNumUsers() public view returns (uint256) {
        return _allUsers.length();
    }

    function getAllUsers() public view returns (address[] memory) {
        return _allUsers.values();
    }

    function getAllUsersRange(uint256 start, uint256 maxSize) public view returns (address[] memory) {
        uint256 arrayLength = _allUsers.length();

        if (start >= arrayLength) {
            return new address[](0);
        }

        uint256 size = (start + maxSize > arrayLength) ? arrayLength - start : maxSize;

        address[] memory users = new address[](size);

        for (uint256 i = 0; i < size; i++) {
            users[i] = _allUsers.at(start + i);
        }
        return users;
    }

    function getUsersOfByCode(
        string memory roleCode_
    ) public view returns (address[] memory) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        bytes32 roleHash = _stringToHash(roleCode_);
        return getUsersOf(roleHash);
    }

    function getUsersOf(bytes32 roleHash_) public view validRole(roleHash_) returns (address[] memory) {
        return _roleUsers[roleHash_].values();
    }

    function hasRoleByCode(
        string memory roleCode_,
        address user_
    ) public view returns (bool) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        DLTValidations.validAddress(user_, 'user_');
        bytes32 roleHash = _stringToHash(roleCode_);
        return hasRole(roleHash, user_);
    }

    function hasRole(
        bytes32 roleHash_,
        address user_
    ) public view override(IDLTRoleManager, AccessControl) validRole(roleHash_) returns (bool) {
        DLTValidations.validAddress(user_, 'user_');
        return super.hasRole(roleHash_, user_);
    }

    function grantRoleByCode(
        string memory roleCode_,
        address user_
    ) public onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        DLTValidations.validAddress(user_, 'user_');
        bytes32 roleHash = _stringToHash(roleCode_);
        grantRole(roleHash, user_);
    }

    function grantRole(
        bytes32 roleHash_,
        address user_
    ) public override(IDLTRoleManager, AccessControl) onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validAddress(user_, 'user_');
        require(!hasRole(roleHash_, user_), 'DLTRoleManager: User already has the role');
        super.grantRole(roleHash_, user_);
        _roleUsers[roleHash_].add(user_);
        _userRoles[user_].add(roleHash_);
        _refreshAllUsers(user_);
    }

    function getRolesOf(address user_) public view returns (bytes32[] memory) {
        DLTValidations.validAddress(user_, 'user_');
        return _userRoles[user_].values();
    }

    function setupRoleByCode(
        string memory roleCode_,
        address user_
    ) public onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        bytes32 roleHash = _stringToHash(roleCode_);
        setupRole(roleHash, user_);
    }

    function setupRole(bytes32 roleHash_, address user_) public onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validAddress(user_, 'user_');
        if (!hasRole(roleHash_, user_)) {
            super.grantRole(roleHash_, user_);
            _roleUsers[roleHash_].add(user_);
            _userRoles[user_].add(roleHash_);
            _refreshAllUsers(user_);
        }
    }

    function revokeRoleByCode(
        string memory roleCode_,
        address user_
    ) public onlyRole(USER_MANAGER_ROLE) {
        DLTValidations.validString(roleCode_, 'roleCode_');
        bytes32 roleHash = _stringToHash(roleCode_);
        revokeRole(roleHash, user_);
    }

    function revokeRole(
        bytes32 roleHash_,
        address user_
    )
        public
        override(IDLTRoleManager, AccessControl)
        onlyRole(USER_MANAGER_ROLE)        
        validHasRole(user_, roleHash_)
        validAllowRevoke(user_)
    {
        DLTValidations.validAddress(user_, 'user_');
        super.revokeRole(roleHash_, user_);
        _roleUsers[roleHash_].remove(user_);
        _userRoles[user_].remove(roleHash_);
        _refreshAllUsers(user_);
    }

    function renounceRoleByCode(string memory roleCode_, address callerConfirmation_) public {
        DLTValidations.validString(roleCode_, 'roleCode_');
        bytes32 roleHash = _stringToHash(roleCode_);
        renounceRole(roleHash, callerConfirmation_);
    }

    function renounceRole(
        bytes32 roleHash_,
        address callerConfirmation_
    )
        public
        override(IDLTRoleManager, AccessControl)        
        validHasRole(callerConfirmation_, roleHash_)
    {
        DLTValidations.validAddress(callerConfirmation_, 'callerConfirmation_');
        super.renounceRole(roleHash_, callerConfirmation_);
        _roleUsers[roleHash_].remove(callerConfirmation_);
        _userRoles[callerConfirmation_].remove(roleHash_);
        _refreshAllUsers(callerConfirmation_);
    }

    function revokeAllRoles(
        address user_
    ) public onlyRole(USER_MANAGER_ROLE) validAllowRevoke(user_) {
        DLTValidations.validAddress(user_, 'user_');
        bytes32[] memory roleHashs = getRolesOf(user_);
        for (uint256 i = 0; i < roleHashs.length; i++) {
            super.revokeRole(roleHashs[i], user_);
            _roleUsers[roleHashs[i]].remove(user_);
            _userRoles[user_].remove(roleHashs[i]);
        }
        _refreshAllUsers(user_);
    }
}
