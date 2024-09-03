// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IDLTStorage } from '../IDLTStorage.sol';
import { KYCData } from '../../models/publicDir/KYCData.sol';
import { KYCStatus } from '../../common/KYCStatus.sol';
import { IDLTLogic } from '../IDLTLogic.sol';

/// @title IDLTKYCDataLogic
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTKYCDataLogic is IDLTLogic {
    // Events
    event KYCRequested(uint256 indexed requestId, address indexed wallet, bytes32 indexed emailHash);
    event KYCRemoved(uint256 indexed requestId, address indexed wallet, bytes32 indexed emailHash);
    event KYCApproved(uint256 indexed requestId, address indexed wallet, bytes32 indexed emailHash);
    event KYCRejected(uint256 indexed requestId, address indexed wallet, bytes32 indexed emailHash);
    event KYCReset(uint256 indexed requestId, address indexed wallet, bytes32 indexed emailHash);

    // Data basic functions
    function setStatusByRequestId(uint256 requestId_, KYCStatus globalStatus_, bytes32 privateTxHash_) external;

    function setStatusByEmailHash(bytes32 emailHash_, KYCStatus globalStatus_, bytes32 privateTxHash_) external;

    function setStatusByWallet(address wallet_, KYCStatus globalStatus_, bytes32 privateTxHash_) external;

    function setData(KYCData memory kycData) external;

    function removeData(uint256 requestId) external;

    function getData(uint256 requestId) external view returns (KYCData memory);

    function existData(uint256 requestId) external view returns (bool);

    // Additional information methods
    function getKYCDataByEmail(string memory email) external view returns (KYCData memory);

    function getKYCDataByEmailHash(bytes32 emailHash) external view returns (KYCData memory);

    function getKYCDataByWallet(address wallet) external view returns (KYCData memory);

    function getKYCGeneralStatusByEmail(string memory email) external view returns (KYCStatus);

    function getKYCGeneralStatusByEmailHash(bytes32 emailHash) external view returns (KYCStatus);

    function getKYCGeneralStatusByWallet(address wallet) external view returns (KYCStatus);
}
