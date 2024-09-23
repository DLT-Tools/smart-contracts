// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { KYCRequest } from './KYCRequest.sol';
import { KYCData } from './KYCData.sol';

struct KYCTuple {
    KYCRequest request;
    KYCData data;
}
