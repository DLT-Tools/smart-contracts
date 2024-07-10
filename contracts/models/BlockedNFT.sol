// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

struct BlockedNFT {
    address contractAddress;
    uint256 tokenId;
    string reasonBlocking;
    bool isBlocked;
}