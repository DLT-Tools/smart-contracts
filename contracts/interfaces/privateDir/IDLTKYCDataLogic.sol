// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IDLTStorage } from '../IDLTStorage.sol';
import { KYCData } from '../../models/privateDir/KYCData.sol';
import { KYCRequest } from '../../models/privateDir/KYCRequest.sol';
import { KYCStatus } from '../../common/KYCStatus.sol';
import { IDLTLogic } from '../IDLTLogic.sol';

/// @title IDLTKYCDataLogic
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTKYCDataLogic is IDLTLogic {
    // Events
    event KYCRequested(uint256 indexed requestId, address indexed wallet, string indexed email);
    event KYCUpdated(uint256 indexed requestId, address indexed wallet, string indexed email);
    event KYCRemoved(uint256 indexed requestId, address wallet, string email);
    event KYCApproved(uint256 indexed requestId, KYCStatus documentStatus, KYCStatus residenceStatus);
    event KYCRejected(uint256 indexed requestId, KYCStatus documentStatus, KYCStatus residenceStatus);
    event KYCReset(uint256 indexed requestId, KYCStatus documentStatus, KYCStatus residenceStatus);
    event ImageAdded(uint256 indexed requestId, string imageUrl);
    event ImageUpdated(uint256 indexed requestId, uint256 imageIndex, string oldImageUrl, string newImageUrl);
    event AllImagesReplaced(uint256 indexed requestId, uint256 imagesNum);
    event ImageRemoved(uint256 indexed requestId, uint256 imageIndex, string imageUrl);

    // Methods

    function addData(KYCData memory kycData, string[] memory images) external;

    function updateData(KYCData memory updatedKYCData) external;

    function removeData(uint256 requestId) external;

    function getData(uint256 requestId) external view returns (KYCData memory);

    function existData(uint256 requestId) external view returns (bool);

    // Images basic functions

    function addImage(uint256 requestId, string memory imageUrl) external;

    function updateImage(uint256 requestId, uint256 indexImage, string memory imageUrl) external;

    function replaceImages(uint256 requestId, string[] memory images) external;

    function removeImage(uint256 requestId, uint256 imageIndex) external;

    function getImages(uint256 requestId) external view returns (string[] memory);

    // Admin special functions

    function approveKYC(uint256 requestId, bool approveDocument, bool approveResidence) external;

    function rejectKYC(
        uint256 requestId,
        bool rejectDocument,
        string memory documentReason,
        bool rejectResidence,
        string memory residenceReason
    ) external;

    function resetKYC(
        uint256 requestId,
        bool resetDocument,
        string memory documentReason,
        bool resetResidence,
        string memory residenceReason
    ) external;

    // Additional information methods

    function getKYCRequestByEmail(string memory email) external view returns (KYCRequest memory);

    function getKYCRequestByWallet(address wallet) external view returns (KYCRequest memory);

    function getKYCRequestByRequestId(uint256 requestId) external view returns (KYCRequest memory);

    function getKYCGeneralStateByEmail(string memory email) external view returns (bool);

    function getKYCGeneralStateByWallet(address wallet) external view returns (bool);

    function getKYCGeneralStateByRequestId(uint256 requestId_) external view returns (bool);

    function getKYCGeneralStatusByEmail(string memory email) external view returns (KYCStatus);

    function getKYCGeneralStatusByWallet(address wallet) external view returns (KYCStatus);

    function getKYCGeneralStatusByRequestId(uint256 requestId_) external view returns (KYCStatus);
}
