// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

string constant PAUSER_ROLE_CODE = 'PAUSER_ROLE';
string constant USER_MANAGER_ROLE_CODE = 'USER_MANAGER_ROLE';
string constant BLACKLIST_MANAGER_ROLE_CODE = 'BLACKLIST_MANAGER_ROLE';
string constant REALESTATE_MANAGER_ROLE_CODE = 'REALESTATE_MANAGER_ROLE';
string constant DEFAULT_ADMIN_ROLE_CODE = 'DEFAULT_ADMIN_ROLE';
string constant MINTER_ROLE_CODE = 'MINTER_ROLE';
string constant TREASURER_ROLE_CODE = 'TREASURER_ROLE';
string constant KYC_MANAGER_ROLE_CODE = 'KYC_MANAGER_ROLE';
string constant KYC_BACKEND_ROLE_CODE = 'KYC_BACKEND_ROLE';

// 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a
bytes32 constant PAUSER_ROLE = keccak256(bytes(PAUSER_ROLE_CODE));
// 0xcbaaf41b181bb6e269c490e876a7c97711b57e21dd8e5528423cf57579726b35
bytes32 constant USER_MANAGER_ROLE = keccak256(bytes(USER_MANAGER_ROLE_CODE));
// 0xf988e4fb62b8e14f4820fed03192306ddf4d7dbfa215595ba1c6ba4b76b369ee
bytes32 constant BLACKLIST_MANAGER_ROLE = keccak256(bytes(BLACKLIST_MANAGER_ROLE_CODE));
// 0xce15ec089bcdf0e3c13da04b23d1a8d548b33d67c230f16b3f368320b1ee519b
bytes32 constant REALESTATE_MANAGER_ROLE = keccak256(bytes(REALESTATE_MANAGER_ROLE_CODE));
// 0x0000000000000000000000000000000000000000000000000000000000000000
bytes32 constant DEFAULT_ADMIN_ROLE = 0x00;
// 0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6
bytes32 constant MINTER_ROLE = keccak256(bytes(MINTER_ROLE_CODE));
// 0x3496e2e73c4d42b75d702e60d9e48102720b8691234415963a5a857b86425d07
bytes32 constant TREASURER_ROLE = keccak256(bytes(TREASURER_ROLE_CODE));
// 0x6f35daacd116f0f629c42d5459fd6842d505964e6828899d889573dc5bc51cf8
bytes32 constant KYC_MANAGER_ROLE = keccak256(bytes(KYC_MANAGER_ROLE_CODE));
// 0x58e0e2d3e57239a6fcc6a52815c03b13f6c7379e29a0633cfcb4eb8c0b72d877
bytes32 constant KYC_BACKEND_ROLE = keccak256(bytes(KYC_BACKEND_ROLE_CODE));

string constant PAUSER_ROLE_DESCRIPTION = 'Contract pauser role';
string constant USER_MANAGER_ROLE_DESCRIPTION = 'User manager role';
string constant BLACKLIST_MANAGER_ROLE_DESCRIPTION = 'Blacklist users and NFTs manager role';
string constant REALESTATE_MANAGER_ROLE_DESCRIPTION = 'Real estate manager role';
string constant DEFAULT_ADMIN_ROLE_DESCRIPTION = 'Default admin role';
string constant MINTER_ROLE_DESCRIPTION = 'Smart contracts and managers who has rol to mint NFTs';
string constant TREASURER_ROLE_DESCRIPTION = 'Manager allowed to manage funds';
string constant KYC_ROLE_DESCRIPTION = 'Manager allowed to manage KYCs';
string constant KYC_BACKEND_ROLE_DESCRIPTION = 'Backend allowed to request KYC of users to verification';
