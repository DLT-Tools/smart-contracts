// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { IDLTConfig } from '../interfaces/publicDir/IDLTConfig.sol';
import { IDLTBlacklistStorage } from '../interfaces/IDLTBlacklistStorage.sol';
import { BlockedNFT } from '../models/BlockedNFT.sol';
import { BlockedWallet } from '../models/BlockedWallet.sol';

library DLTBlacklist {
    // Custom errors
    error WalletIsBlocked(address wallet, string reasonBlocking);
    error NFTIsBlocked(address collection, uint256 tokenId, string reasonBlocking);

    // Methods
    function checkNotBlockedWallet(address dltConfig_, address wallet_) public view {
        address dltBlacklistStorageAddr = IDLTConfig(dltConfig_).getDLTBlacklistStorage();
        BlockedWallet memory blockedWallet = IDLTBlacklistStorage(dltBlacklistStorageAddr).getBlockedWallet(wallet_);
        if (blockedWallet.isBlocked) {
            revert WalletIsBlocked(wallet_, blockedWallet.reasonBlocking);
        }
    }

    function checkNotBlockedNFT(address dltConfig_, address collection_, uint256 tokenId_) public view {
        address dltBlacklistStorageAddr = IDLTConfig(dltConfig_).getDLTBlacklistStorage();
        BlockedNFT memory blockedNFT = IDLTBlacklistStorage(dltBlacklistStorageAddr).getBlockedNFT(collection_, tokenId_);
        if (blockedNFT.isBlocked) {
            revert NFTIsBlocked(collection_, tokenId_, blockedNFT.reasonBlocking);
        }
    }

    function isBlockedWallet(address dltConfig_, address wallet_) public view returns (bool) {
        address dltBlacklistStorageAddr = IDLTConfig(dltConfig_).getDLTBlacklistStorage();
        return IDLTBlacklistStorage(dltBlacklistStorageAddr).getBlockedWallet(wallet_).isBlocked;
    }

    function isBlockedNFT(address dltConfig_, address collection_, uint256 tokenId_) public view returns (bool) {
        address dltBlacklistStorageAddr = IDLTConfig(dltConfig_).getDLTBlacklistStorage();
        return IDLTBlacklistStorage(dltBlacklistStorageAddr).getBlockedNFT(collection_, tokenId_).isBlocked;
    }
}
