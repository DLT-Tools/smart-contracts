// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { IERC721Enumerable } from '@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol';
import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { IERC721 } from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import { DLTBase } from '../base/DLTBase.sol';
import { BlockedNFT } from '../models/BlockedNFT.sol';
import { BlockedWallet } from '../models/BlockedWallet.sol';
import { BLACKLIST_MANAGER_ROLE } from '../common/Roles.sol';
import { IDLTConfig } from '../interfaces/publicDir/IDLTConfig.sol';
import { IDLTBlacklistStorage } from '../interfaces/IDLTBlacklistStorage.sol';
import { IDLTBlacklistLogic } from '../interfaces/IDLTBlacklistLogic.sol';
import { DLTValidations } from '../lib/DLTValidations.sol';

/// @title DLT Blacklist Logic
/// @author DLT-Tools Team
/// @dev This contract contains the logic to manage blacklisted wallets and NFTs.
/// @custom:security-contact support@beruwa.la
contract DLTBlacklistLogic is IDLTBlacklistLogic, DLTBase {
    // Constants

    bytes4 private constant interfaceId_ERC721Enumerable = 0x780e9d63;
    bytes4 private constant interfaceId_ERC721 = 0x80ac58cd;

    // Constructors

    constructor(address dltConfig_) DLTBase(dltConfig_) {}

    // Methods

    function getStorageAddress() public view returns (address) {
        return IDLTConfig(dltConfig).getDLTBlacklistStorage();
    }

    function addWallet(
        BlockedWallet calldata blockedWallet_
    )
        public
        onlyRole(BLACKLIST_MANAGER_ROLE)    
    {
        DLTValidations.validAddress(blockedWallet_.wallet, 'wallet');
        DLTValidations.validString(blockedWallet_.reasonBlocking, 'blockedWallet_.reasonBlocking');
        require(blockedWallet_.isBlocked == true, 'DLTBlacklistLogic: is blocked need to be true');
        address storageAddress_ = getStorageAddress();
        require(
            IDLTBlacklistStorage(storageAddress_).getBlockedWallet(blockedWallet_.wallet).isBlocked == false,
            'DLTBlacklistLogic: wallet already blocked'
        );
        IDLTBlacklistStorage(storageAddress_).setBlockedWallet(blockedWallet_.wallet, blockedWallet_);
        emit WalletAddedToBlacklist(blockedWallet_.wallet);
    }

    function removeWallet(address wallet_) public onlyRole(BLACKLIST_MANAGER_ROLE) {
        DLTValidations.validAddress(wallet_, 'wallet_');
        address storageAddress_ = getStorageAddress();
        require(
            IDLTBlacklistStorage(storageAddress_).getBlockedWallet(wallet_).isBlocked == true,
            'DLTBlacklistLogic: wallet is not blocked'
        );
        BlockedWallet memory unblockedWallet = IDLTBlacklistStorage(storageAddress_).getBlockedWallet(wallet_);
        unblockedWallet.isBlocked = false;
        IDLTBlacklistStorage(storageAddress_).setBlockedWallet(wallet_, unblockedWallet);
        emit WalletRemovedFromBlacklist(wallet_);
    }

    function addNFT(
        BlockedNFT calldata blockedNFT_
    )
        public
        onlyRole(BLACKLIST_MANAGER_ROLE)        
    {
        DLTValidations.validContract(blockedNFT_.contractAddress, 'blockedNFT_.contractAddress');
        DLTValidations.validNFTTokenId(blockedNFT_.contractAddress, blockedNFT_.tokenId, 'blockedNFT_.tokenId');
        DLTValidations.validString(blockedNFT_.reasonBlocking, 'blockedNFT_.reasonBlocking');
        require(blockedNFT_.isBlocked == true, 'DLTBlacklistLogic: is blocked need to be true');
        address storageAddress_ = getStorageAddress();
        bool isBlocked = IDLTBlacklistStorage(storageAddress_)
            .getBlockedNFT(blockedNFT_.contractAddress, blockedNFT_.tokenId)
            .isBlocked == false;
        require(isBlocked, 'DLTBlacklistLogic: NFT already blocked');
        IDLTBlacklistStorage(storageAddress_).setBlockedNFT(blockedNFT_.contractAddress, blockedNFT_.tokenId, blockedNFT_);
        emit NFTAddedToBlacklist(blockedNFT_.contractAddress, blockedNFT_.tokenId);
    }

    function removeNFT(
        address contractAddress_,
        uint256 tokenId_
    )
        public
        onlyRole(BLACKLIST_MANAGER_ROLE)        
    {
        DLTValidations.validContract(contractAddress_, 'contractAddress_');
        DLTValidations.validNFTTokenId(contractAddress_, tokenId_, 'tokenId_');
        address storageAddress_ = getStorageAddress();
        require(
            IDLTBlacklistStorage(storageAddress_).getBlockedNFT(contractAddress_, tokenId_).isBlocked == true,
            'DLTBlacklistLogic: NFT is not blocked'
        );
        BlockedNFT memory unblockedNFT = IDLTBlacklistStorage(storageAddress_).getBlockedNFT(contractAddress_, tokenId_);
        unblockedNFT.isBlocked = false;
        IDLTBlacklistStorage(storageAddress_).setBlockedNFT(contractAddress_, tokenId_, unblockedNFT);
        emit NFTRemovedFromBlacklist(contractAddress_, tokenId_);
    }

    // Return blocked token id's in specified collection and filtered by owner
    function getBlockedNFTs(
        address contractAddress_,
        address owner_
    ) public view returns (uint256[] memory) {
        DLTValidations.validContract(contractAddress_, 'contractAddress_');
        DLTValidations.validAddress(owner_, 'owner_');
        IERC165 candidateContract = IERC165(contractAddress_);
        require(
            candidateContract.supportsInterface(interfaceId_ERC721),
            'DLTBlacklistLogic: contract address need to support ERC721 interface'
        );
        require(
            candidateContract.supportsInterface(interfaceId_ERC721Enumerable),
            'DLTBlacklistLogic: contract address need to support ERC721 Enumerable interface'
        );

        address storageAddress_ = getStorageAddress();
        uint256 balance = IERC721(contractAddress_).balanceOf(owner_);
        uint256[] memory blockedNFTs = new uint256[](balance);
        uint256 counter = 0;

        for (uint256 index = 0; index < balance; index++) {
            uint256 tokenId = IERC721Enumerable(contractAddress_).tokenOfOwnerByIndex(owner_, index);
            BlockedNFT memory blockedNFT = IDLTBlacklistStorage(storageAddress_).getBlockedNFT(contractAddress_, tokenId);
            if (blockedNFT.isBlocked) {
                blockedNFTs[counter] = tokenId;
                counter++;
            }
        }

        uint256[] memory result = new uint256[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = blockedNFTs[i];
        }

        return result;
    }
}
