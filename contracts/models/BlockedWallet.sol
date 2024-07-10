// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

struct BlockedWallet {
    address wallet;
    string reasonBlocking;
    bool isBlocked;
}
