// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { KYCRequest } from './KYCRequest.sol';
import { KYCData } from './KYCData.sol';

struct KYCTuple {
    KYCRequest request;
    KYCData data;
}
