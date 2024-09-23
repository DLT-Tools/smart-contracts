// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { KYCStatus } from '../../common/KYCStatus.sol';

struct KYCData {
    uint256 id;
    bytes32 emailHash;
    address wallet;
    KYCStatus status;
    bytes32 privateTxHash;
}
