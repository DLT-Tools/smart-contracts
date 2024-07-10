// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { DLTBase } from '../../base/DLTBase.sol';
import { KYCStatus } from '../../common/KYCStatus.sol';
import { KYC_BACKEND_ROLE } from '../../common/Roles.sol';
import { IDLTKYCDataLogic } from '../../interfaces/private/IDLTKYCDataLogic.sol';
import { IDLTKYCDataStorage } from '../../interfaces/private/IDLTKYCDataStorage.sol';
import { IDLTConfig } from '../../interfaces/private/IDLTConfig.sol';
import { KYCData } from '../../models/private/KYCData.sol';
import { KYCRequest } from '../../models/private/KYCRequest.sol';

contract DLTKYCDataLogic is IDLTKYCDataLogic, DLTBase {
    constructor(address dltConfig_) DLTBase(dltConfig_) {}

    function getStorageAddress() public view returns (address) {
        return IDLTConfig(dltConfig).getDLTKYCDataStorage();
    }

    function _validData(KYCData memory kycData_) internal pure {
        require(bytes(kycData_.fullName).length > 0, 'DLTKYCDataLogic: Full name is required');
        require(kycData_.birthDate > 0, 'DLTKYCDataLogic: Date of birth is required');
        require(bytes(kycData_.residenceAddress).length > 0, 'DLTKYCDataLogic: Residence address is required');
        require(bytes(kycData_.nationality).length > 0, 'DLTKYCDataLogic: Nationality is required');
        require(bytes(kycData_.documentType).length > 0, 'DLTKYCDataLogic: Document type is required');
        require(bytes(kycData_.documentNumber).length > 0, 'DLTKYCDataLogic: Document number is required');
        require(bytes(kycData_.countryOfNationality).length > 0, 'DLTKYCDataLogic: Country of nationality is required');
    }

    // Data basic functions

    function addData(KYCData memory kycData_, string[] memory images_) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        _validData(kycData_);
        //_validKYCDuplication(kycData_);
        address storageAddress = getStorageAddress();
        IDLTKYCDataStorage(storageAddress).incrementIdCounter();
        uint256 id = IDLTKYCDataStorage(storageAddress).getIdCounter();
        kycData_.id = id;
        IDLTKYCDataStorage(storageAddress).setData(id, kycData_);
        IDLTKYCDataStorage(storageAddress).setImages(id, images_);
        KYCRequest memory request = KYCRequest({
            id: id,
            documentStatus: KYCStatus.Pending,
            documentReason: '',
            residenceStatus: KYCStatus.Pending,
            residenceReason: ''
        });
        IDLTKYCDataStorage(storageAddress).setRequest(id, request);
        emit KYCRequested(id, kycData_.wallet, kycData_.email);
    }

    function updateData(KYCData memory updatedKYCData_) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        _validData(updatedKYCData_);
        address storageAddress = getStorageAddress();
        IDLTKYCDataStorage(storageAddress).setData(updatedKYCData_.id, updatedKYCData_);
        emit KYCUpdated(updatedKYCData_.id, updatedKYCData_.wallet, updatedKYCData_.email);
    }

    function removeData(uint256 requestId_) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        address storageAddress = getStorageAddress();
        KYCData memory data = IDLTKYCDataStorage(storageAddress).getData(requestId_);
        IDLTKYCDataStorage(storageAddress).removeData(requestId_);
        emit KYCRemoved(requestId_, data.wallet, data.email);
    }

    function getData(uint256 requestId_) public view returns (KYCData memory) {
        address storageAddress = getStorageAddress();
        return IDLTKYCDataStorage(storageAddress).getData(requestId_);
    }

    function existData(uint256 requestId_) public view returns (bool) {
        address storageAddress = getStorageAddress();
        KYCData memory data = IDLTKYCDataStorage(storageAddress).getData(requestId_);
        return data.id == requestId_;
    }

    // Images basic functions

    function addImage(uint256 requestId_, string memory imageUrl_) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        address storageAddress = getStorageAddress();
        IDLTKYCDataStorage(storageAddress).addImage(requestId_, imageUrl_);
        emit ImageAdded(requestId_, imageUrl_);
    }

    function updateImage(
        uint256 requestrequestId_,
        uint256 indexImage_,
        string memory imageUrl_
    ) external onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        address storageAddress = getStorageAddress();
        string memory oldImageUrl = IDLTKYCDataStorage(storageAddress).getImage(requestrequestId_, indexImage_);
        IDLTKYCDataStorage(storageAddress).setImage(requestrequestId_, indexImage_, imageUrl_);
        emit ImageUpdated(requestrequestId_, indexImage_, oldImageUrl, imageUrl_);
    }

    function replaceImages(uint256 requestId_, string[] memory images_) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        address storageAddress = getStorageAddress();
        IDLTKYCDataStorage(storageAddress).setImages(requestId_, images_);
        emit AllImagesReplaced(requestId_, images_.length);
    }

    function removeImage(uint256 requestId_, uint256 imageIndex_) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        address storageAddress = getStorageAddress();
        string memory imageUrl = IDLTKYCDataStorage(storageAddress).getImages(requestId_)[imageIndex_];
        IDLTKYCDataStorage(storageAddress).removeImage(requestId_, imageIndex_);
        emit ImageRemoved(requestId_, imageIndex_, imageUrl);
    }

    function getImages(uint256 requestId_) public view returns (string[] memory) {
        address storageAddress = getStorageAddress();
        return IDLTKYCDataStorage(storageAddress).getImages(requestId_);
    }

    // Admin special functions

    function approveKYC(
        uint256 requestId_,
        bool approveDocument_,
        bool approveResidence_
    ) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(approveDocument_ || approveResidence_, 'DLTKYCDataLogic: Nothing to approve!');
        require(requestId_ > 0, 'DLTKYCDataLogic: KYC request id is zero!');
        address storageAddress = getStorageAddress();
        KYCRequest memory request = IDLTKYCDataStorage(storageAddress).getRequest(requestId_);
        if (approveDocument_) {
            require(request.documentStatus == KYCStatus.Pending, 'DLTKYCDataLogic: KYC request for document is not pending');
            request.documentStatus = KYCStatus.Approved;
        }
        if (approveResidence_) {
            require(request.residenceStatus == KYCStatus.Pending, 'DLTKYCDataLogic: KYC request for residence is not pending');
            request.residenceStatus = KYCStatus.Approved;
        }
        IDLTKYCDataStorage(storageAddress).setRequest(requestId_, request);
        emit KYCApproved(requestId_, request.documentStatus, request.residenceStatus);
    }

    function rejectKYC(
        uint256 requestId_,
        bool rejectDocument_,
        string memory documentReason_,
        bool rejectResidence_,
        string memory residenceReason_
    ) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(rejectDocument_ || rejectResidence_, 'DLTKYCDataLogic: Nothing to reject!');
        require(requestId_ > 0, 'DLTKYCDataLogic: KYC request id is zero!');
        address storageAddress = getStorageAddress();
        KYCRequest memory request = IDLTKYCDataStorage(storageAddress).getRequest(requestId_);
        if (rejectDocument_) {
            require(request.documentStatus == KYCStatus.Pending, 'DLTKYCDataLogic: KYC request for document is not pending');
            request.documentStatus = KYCStatus.Rejected;
            request.documentReason = documentReason_;
        }
        if (rejectResidence_) {
            require(request.residenceStatus == KYCStatus.Pending, 'DLTKYCDataLogic: KYC request for residence is not pending');
            request.residenceStatus = KYCStatus.Rejected;
            request.residenceReason = residenceReason_;
        }
        IDLTKYCDataStorage(storageAddress).setRequest(requestId_, request);
        emit KYCRejected(requestId_, request.documentStatus, request.residenceStatus);
    }

    function resetKYC(
        uint256 requestId_,
        bool resetDocument_,
        string memory documentReason_,
        bool resetResidence_,
        string memory residenceReason_
    ) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(resetDocument_ || resetResidence_, 'DLTKYCDataLogic: Nothing to reset!');
        require(requestId_ > 0, 'DLTKYCDataLogic: KYC request id is zero!');
        address storageAddress = getStorageAddress();
        KYCRequest memory request = IDLTKYCDataStorage(storageAddress).getRequest(requestId_);
        if (resetDocument_) {
            request.documentStatus = KYCStatus.Unknown;
            request.documentReason = documentReason_;
        }
        if (resetResidence_) {
            request.residenceStatus = KYCStatus.Unknown;
            request.residenceReason = residenceReason_;
        }
        IDLTKYCDataStorage(storageAddress).setRequest(requestId_, request);
        emit KYCReset(requestId_, request.documentStatus, request.residenceStatus);
    }

    // Additional information methods

    function getKYCRequestByEmail(string memory email_) public view returns (KYCRequest memory) {
        require(bytes(email_).length > 0, 'DLTKYCDataLogic: Email is empty');
        address storageAddress = getStorageAddress();
        uint256 id = IDLTKYCDataStorage(storageAddress).getIdByEmail(email_);
        require(id > 0, 'DLTKYCDataLogic: KYC request for this email not exists!');
        KYCRequest memory request = IDLTKYCDataStorage(storageAddress).getRequest(id);
        return request;
    }

    function getKYCRequestByWallet(address wallet_) public view returns (KYCRequest memory) {
        require(wallet_ != address(0), 'DLTKYCDataLogic: wallet address is zero');
        address storageAddress = getStorageAddress();
        uint256 id = IDLTKYCDataStorage(storageAddress).getIdByWallet(wallet_);
        require(id > 0, 'DLTKYCDataLogic: KYC request for this wallet not exists!');
        KYCRequest memory request = IDLTKYCDataStorage(storageAddress).getRequest(id);
        return request;
    }

    function getKYCRequestByRequestId(uint256 requestId_) public view returns (KYCRequest memory) {
        require(requestId_ != 0, 'DLTKYCDataLogic: request id is zero');
        address storageAddress = getStorageAddress();
        KYCRequest memory request = IDLTKYCDataStorage(storageAddress).getRequest(requestId_);
        return request;
    }

    function getKYCGeneralStateByEmail(string memory email_) public view returns (bool) {
        KYCRequest memory request = getKYCRequestByEmail(email_);
        return request.documentStatus == KYCStatus.Approved && request.residenceStatus == KYCStatus.Approved;
    }

    function getKYCGeneralStateByWallet(address wallet_) public view returns (bool) {
        KYCRequest memory request = getKYCRequestByWallet(wallet_);
        return request.documentStatus == KYCStatus.Approved && request.residenceStatus == KYCStatus.Approved;
    }

    function getKYCGeneralStateByRequestId(uint256 requestId_) public view returns (bool) {
        KYCRequest memory request = getKYCRequestByRequestId(requestId_);
        return request.documentStatus == KYCStatus.Approved && request.residenceStatus == KYCStatus.Approved;
    }

    function getKYCGeneralStatusByEmail(string memory email_) public view returns (KYCStatus) {
        KYCRequest memory request = getKYCRequestByEmail(email_);
        return _getGeneralStatusByRequest(request);
    }

    function getKYCGeneralStatusByWallet(address wallet_) public view returns (KYCStatus) {
        KYCRequest memory request = getKYCRequestByWallet(wallet_);
        return _getGeneralStatusByRequest(request);
    }

    function getKYCGeneralStatusByRequestId(uint256 requestId_) public view returns (KYCStatus) {
        KYCRequest memory request = getKYCRequestByRequestId(requestId_);
        return _getGeneralStatusByRequest(request);
    }

    // Private methods

    function _getGeneralStatusByRequest(KYCRequest memory request_) internal pure returns (KYCStatus) {
        KYCStatus status;
        if (request_.documentStatus == KYCStatus.Approved && request_.residenceStatus == KYCStatus.Approved) {
            status = KYCStatus.Approved;
        } else if (request_.documentStatus == KYCStatus.Rejected && request_.residenceStatus == KYCStatus.Rejected) {
            status = KYCStatus.Rejected;
        } else if (request_.documentStatus == KYCStatus.Unknown && request_.residenceStatus == KYCStatus.Unknown) {
            status = KYCStatus.Unknown;
        } else {
            status = KYCStatus.Pending;
        }
        return status;
    }
}
