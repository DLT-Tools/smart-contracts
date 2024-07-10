// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { BlockedNFT } from '../models/BlockedNFT.sol';
import { BlockedWallet } from '../models/BlockedWallet.sol';
import { IDLTStorage } from './IDLTStorage.sol';

/// @title IDLTBlacklistStorage
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTBlacklistStorage is IDLTStorage {
    function getNumWallets() external view returns (uint256);

    function getAllWalletsRange(uint256 start, uint256 maxSize) external view returns (address[] memory);

    function setBlockedWallet(address wallet_, BlockedWallet memory data_) external;

    function getBlockedWallet(address wallet_) external view returns (BlockedWallet memory);

    function getNumCollections() external view returns (uint256);

    function getAllCollectionsRange(uint256 start, uint256 maxSize) external view returns (address[] memory);

    function getNumNFTs(address collection_) external view returns (uint256);

    function getAllNFTsRange(address collection_, uint256 start, uint256 maxSize) external view returns (uint256[] memory);

    function setBlockedNFT(address contractAddress_, uint256 tokenId_, BlockedNFT memory data_) external;

    function getBlockedNFT(address contractAddress_, uint256 tokenId_) external view returns (BlockedNFT memory);
}
