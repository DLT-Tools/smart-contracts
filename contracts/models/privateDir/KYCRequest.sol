// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { KYCStatus } from '../../common/KYCStatus.sol';

struct KYCRequest {
    uint256 id;
    KYCStatus documentStatus;
    string documentReason;
    KYCStatus residenceStatus;
    string residenceReason;
}
