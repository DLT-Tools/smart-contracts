// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { DLTBase } from '../base/DLTBase.sol';
import { BlockedNFT } from '../models/BlockedNFT.sol';
import { BlockedWallet } from '../models/BlockedWallet.sol';
import { BLACKLIST_MANAGER_ROLE, DEFAULT_ADMIN_ROLE } from '../common/Roles.sol';
import { IDLTConfig } from '../interfaces/publicDir/IDLTConfig.sol';
import { IDLTBlacklistStorage } from '../interfaces/IDLTBlacklistStorage.sol';
import { EnumerableSet } from '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

/// @title DLTBlacklistStorage
/// @author DLT-Tools Team
/// @dev Storage contract for managing blacklisted wallets and NFTs for DLT.
/// @custom:security-contact support@beruwa.la
contract DLTBlacklistStorage is IDLTBlacklistStorage, DLTBase {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;

    /// @dev Mapping of blacklisted wallets.
    mapping(address => BlockedWallet) private _blockedWallets;
    /// @dev Nested mapping for blacklisted NFTs. Mapping of contract address to token ID.
    mapping(address => mapping(uint256 => BlockedNFT)) private _blockedNFTs;
    EnumerableSet.AddressSet private _allWallets;
    mapping(address => EnumerableSet.UintSet) private _allNFTs;
    EnumerableSet.AddressSet private _allCollections;

    /// @notice Restricts function calls to the associated logic contract.
    modifier onlyLogicContract() {
        require(msg.sender == getLogicAddress(), 'DLTBlacklistStorage: Only logic contract can access');
        _;
    }

    constructor(address dltConfig_) DLTBase(dltConfig_) {}

    function getLogicAddress() public view returns (address) {
        return IDLTConfig(dltConfig).getDLTBlacklistLogic();
    }

    function getNumWallets() public view returns (uint256) {
        return _allWallets.length();
    }

    function getAllWalletsRange(uint256 start, uint256 maxSize) public view returns (address[] memory) {
        uint256 arrayLength = _allWallets.length();

        if (start >= arrayLength) {
            return new address[](0);
        }

        uint256 size = (start + maxSize > arrayLength) ? arrayLength - start : maxSize;

        address[] memory wallets = new address[](size);

        for (uint256 i = 0; i < size; i++) {
            wallets[i] = _allWallets.at(start + i);
        }
        return wallets;
    }

    /// @notice Stores a blacklisted wallet's data.
    /// @dev Can only be called by the associated logic contract.
    /// @param wallet_ Address of the wallet.
    /// @param data_ The wallet's data to be stored.
    function setBlockedWallet(address wallet_, BlockedWallet memory data_) external onlyLogicContract {
        _blockedWallets[wallet_] = data_;
        if (data_.isBlocked && !_allWallets.contains(wallet_)) {
            _allWallets.add(wallet_);
        } else if (!data_.isBlocked && _allWallets.contains(wallet_)) {
            _allWallets.remove(wallet_);
        }
    }

    /// @notice Retrieves data of a blacklisted wallet.
    /// @param wallet_ Address of the blacklisted wallet.
    /// @return The wallet's data.
    function getBlockedWallet(address wallet_) public view returns (BlockedWallet memory) {
        return _blockedWallets[wallet_];
    }

    function getNumCollections() public view returns (uint256) {
        return _allCollections.length();
    }

    function getAllCollectionsRange(uint256 start, uint256 maxSize) public view returns (address[] memory) {
        uint256 arrayLength = _allCollections.length();

        if (start >= arrayLength) {
            return new address[](0);
        }

        uint256 size = (start + maxSize > arrayLength) ? arrayLength - start : maxSize;

        address[] memory collections = new address[](size);

        for (uint256 i = 0; i < size; i++) {
            collections[i] = _allCollections.at(start + i);
        }
        return collections;
    }

    function getNumNFTs(address collection_) public view returns (uint256) {
        return _allNFTs[collection_].length();
    }

    function getAllNFTsRange(address collection_, uint256 start, uint256 maxSize) public view returns (uint256[] memory) {
        uint256 arrayLength = _allNFTs[collection_].length();

        if (start >= arrayLength) {
            return new uint256[](0);
        }

        uint256 size = (start + maxSize > arrayLength) ? arrayLength - start : maxSize;

        uint256[] memory nfts = new uint256[](size);

        for (uint256 i = 0; i < size; i++) {
            nfts[i] = _allNFTs[collection_].at(start + i);
        }
        return nfts;
    }

    /// @notice Stores a blacklisted NFT's data.
    /// @dev Can only be called by the associated logic contract.
    /// @param contractAddress_ Address of the NFT contract.
    /// @param tokenId_ Token ID of the blacklisted NFT.
    /// @param data_ The NFT's data to be stored.
    function setBlockedNFT(address contractAddress_, uint256 tokenId_, BlockedNFT memory data_) external onlyLogicContract {
        _blockedNFTs[contractAddress_][tokenId_] = data_;
        if (data_.isBlocked) {
            if (!_allCollections.contains(contractAddress_)) {
                _allCollections.add(contractAddress_);
            }
            if (!_allNFTs[contractAddress_].contains(tokenId_)) {
                _allNFTs[contractAddress_].add(tokenId_);
            }
        } else if (!data_.isBlocked) {
            if (_allNFTs[contractAddress_].contains(tokenId_)) {
                _allNFTs[contractAddress_].remove(tokenId_);
            }
            if (_allNFTs[contractAddress_].length() == 0) {
                _allCollections.remove(contractAddress_);
            }
        }
    }

    /// @notice Retrieves data of a blacklisted NFT.
    /// @param contractAddress_ Address of the NFT contract.
    /// @param tokenId_ Token ID of the blacklisted NFT.
    /// @return The NFT's data.
    function getBlockedNFT(address contractAddress_, uint256 tokenId_) public view returns (BlockedNFT memory) {
        return _blockedNFTs[contractAddress_][tokenId_];
    }
}
