// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { BlockedNFT } from '../models/BlockedNFT.sol';
import { BlockedWallet } from '../models/BlockedWallet.sol';
import { IDLTConfig } from './publicDir/IDLTConfig.sol';
import { IDLTBlacklistStorage } from './IDLTBlacklistStorage.sol';
import { IDLTLogic } from './IDLTLogic.sol';

/// @title IDLTBlacklistLogic
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTBlacklistLogic is IDLTLogic {
    // Events

    /// @notice Emitted when a wallet is added to the blacklist.
    event WalletAddedToBlacklist(address indexed wallet);

    /// @notice Emitted when a wallet is removed from the blacklist.
    event WalletRemovedFromBlacklist(address indexed wallet);

    /// @notice Emitted when an NFT is added to the blacklist.
    event NFTAddedToBlacklist(address indexed contractAddress, uint256 indexed tokenId);

    /// @notice Emitted when an NFT is removed from the blacklist.
    event NFTRemovedFromBlacklist(address indexed contractAddress, uint256 indexed tokenId);

    // Methods

    function addWallet(BlockedWallet calldata blockedWallet_) external;

    function removeWallet(address wallet_) external;

    function addNFT(BlockedNFT calldata blockedNFT_) external;

    function removeNFT(address contractAddress_, uint256 tokenId_) external;

    function getBlockedNFTs(address contractAddress_, address owner_) external view returns (uint256[] memory);
}
