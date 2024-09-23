// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { IDLTConfig } from '../interfaces/publicDir/IDLTConfig.sol';
import { IDLTBlacklistStorage } from '../interfaces/IDLTBlacklistStorage.sol';

library DLTBlacklist {
    function isBlockedWallet(address dltConfig_, address wallet_) public view returns (bool) {
        address dltBlacklistStorageAddr = IDLTConfig(dltConfig_).getDLTBlacklistStorage();
        return IDLTBlacklistStorage(dltBlacklistStorageAddr).getBlockedWallet(wallet_).isBlocked;
    }

    function isBlockedWallet(address dltConfig_, address collection_, uint256 tokenId_) public view returns (bool) {
        address dltBlacklistStorageAddr = IDLTConfig(dltConfig_).getDLTBlacklistStorage();
        return IDLTBlacklistStorage(dltBlacklistStorageAddr).getBlockedNFT(collection_, tokenId_).isBlocked;
    }
}
