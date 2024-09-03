// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { DLTBase } from '../../base/DLTBase.sol';
import { KYCStatus } from '../../common/KYCStatus.sol';
import { KYC_BACKEND_ROLE } from '../../common/Roles.sol';
import { IDLTKYCDataLogic } from '../../interfaces/publicDir/IDLTKYCDataLogic.sol';
import { IDLTKYCDataStorage } from '../../interfaces/publicDir/IDLTKYCDataStorage.sol';
import { IDLTConfig } from '../../interfaces/publicDir/IDLTConfig.sol';
import { KYCData } from '../../models/publicDir/KYCData.sol';

contract DLTKYCDataLogic is IDLTKYCDataLogic, DLTBase {
    constructor(address dltConfig_) DLTBase(dltConfig_) {}

    function getStorageAddress() public view returns (address) {
        return IDLTConfig(dltConfig).getDLTKYCDataStorage();
    }

    function _validData(KYCData memory kycData_) internal pure {
        require(
            kycData_.emailHash != bytes32(0) || kycData_.wallet != address(0),
            'DLTKYCDataLogic: Need to be not empty email or wallet'
        );
        require(kycData_.id > 0, 'DLTKYCDataLogic: User id need to be greater 0');
    }

    function _emitEventByStatus(uint256 requestId_, address wallet_, bytes32 emailHash_, KYCStatus status_) internal {
        if (status_ == KYCStatus.Pending) {
            emit KYCRequested(requestId_, wallet_, emailHash_);
        } else if (status_ == KYCStatus.Approved) {
            emit KYCApproved(requestId_, wallet_, emailHash_);
        } else if (status_ == KYCStatus.Rejected) {
            emit KYCRejected(requestId_, wallet_, emailHash_);
        } else {
            emit KYCReset(requestId_, wallet_, emailHash_);
        }
    }

    // Data basic functions
    function setStatusByRequestId(
        uint256 requestId_,
        KYCStatus globalStatus_,
        bytes32 privateTxHash_
    ) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(requestId_ != 0, 'DLTKYCDataLogic: Request Id need to be greater 0');
        address storageAddress = getStorageAddress();
        KYCData memory kycData = IDLTKYCDataStorage(storageAddress).getData(requestId_);
        kycData.status = globalStatus_;
        kycData.privateTxHash = privateTxHash_;
        IDLTKYCDataStorage(storageAddress).setData(kycData);
        _emitEventByStatus(kycData.id, kycData.wallet, kycData.emailHash, kycData.status);
    }

    function setStatusByEmailHash(
        bytes32 emailHash_,
        KYCStatus globalStatus_,
        bytes32 privateTxHash_
    ) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(emailHash_ != bytes32(0), 'DLTKYCDataLogic: Email hash is empty');
        address storageAddress = getStorageAddress();
        uint256 requestId = IDLTKYCDataStorage(storageAddress).getIdByEmailHash(emailHash_);
        setStatusByRequestId(requestId, globalStatus_, privateTxHash_);
    }

    function setStatusByWallet(
        address wallet_,
        KYCStatus globalStatus_,
        bytes32 privateTxHash_
    ) public onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(wallet_ != address(0), 'DLTKYCDataLogic: Wallet is empty');
        address storageAddress = getStorageAddress();
        uint256 requestId = IDLTKYCDataStorage(storageAddress).getIdByWallet(wallet_);
        setStatusByRequestId(requestId, globalStatus_, privateTxHash_);
    }

    function setData(KYCData memory kycData_) external onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        require(kycData_.id != 0, 'DLTKYCDataLogic: Id need to be greater 0');
        _validData(kycData_);
        address storageAddress = getStorageAddress();
        IDLTKYCDataStorage(storageAddress).setData(kycData_);
        _emitEventByStatus(kycData_.id, kycData_.wallet, kycData_.emailHash, kycData_.status);
    }

    function removeData(uint256 id_) external onlyRole(KYC_BACKEND_ROLE) whenNotPaused {
        address storageAddress = getStorageAddress();
        KYCData memory data = IDLTKYCDataStorage(storageAddress).getData(id_);
        IDLTKYCDataStorage(storageAddress).removeData(id_);
        emit KYCRemoved(id_, data.wallet, data.emailHash);
    }

    function getData(uint256 id_) external view returns (KYCData memory) {
        address storageAddress = getStorageAddress();
        return IDLTKYCDataStorage(storageAddress).getData(id_);
    }

    function existData(uint256 id_) external view returns (bool) {
        address storageAddress = getStorageAddress();
        KYCData memory data = IDLTKYCDataStorage(storageAddress).getData(id_);
        return data.id == id_;
    }

    // Additional information methods
    function getKYCDataByEmail(string memory email_) public view returns (KYCData memory) {
        require(bytes(email_).length > 0, 'DLTKYCDataLogic: Email is empty');
        address storageAddress = getStorageAddress();
        uint256 id = IDLTKYCDataStorage(storageAddress).getIdByEmail(email_);
        require(id > 0, 'DLTKYCDataLogic: KYC request for this email not exists!');
        KYCData memory request = IDLTKYCDataStorage(storageAddress).getData(id);
        return request;
    }

    function getKYCDataByEmailHash(bytes32 emailHash_) public view returns (KYCData memory) {
        require(emailHash_ != bytes32(0), 'DLTKYCDataLogic: Email hash is empty');
        address storageAddress = getStorageAddress();
        uint256 id = IDLTKYCDataStorage(storageAddress).getIdByEmailHash(emailHash_);
        require(id > 0, 'DLTKYCDataLogic: KYC request for this email not exists!');
        KYCData memory request = IDLTKYCDataStorage(storageAddress).getData(id);
        return request;
    }

    function getKYCDataByWallet(address wallet_) public view returns (KYCData memory) {
        require(wallet_ != address(0), 'DLTKYCDataLogic: wallet address is zero');
        address storageAddress = getStorageAddress();
        uint256 id = IDLTKYCDataStorage(storageAddress).getIdByWallet(wallet_);
        require(id > 0, 'DLTKYCDataLogic: KYC request for this wallet not exists!');
        KYCData memory request = IDLTKYCDataStorage(storageAddress).getData(id);
        return request;
    }

    function getKYCGeneralStatusByEmail(string memory email_) public view returns (KYCStatus) {
        KYCData memory data = getKYCDataByEmail(email_);
        return data.status;
    }

    function getKYCGeneralStatusByEmailHash(bytes32 emailHash_) public view returns (KYCStatus) {
        KYCData memory data = getKYCDataByEmailHash(emailHash_);
        return data.status;
    }

    function getKYCGeneralStatusByWallet(address wallet_) public view returns (KYCStatus) {
        KYCData memory data = getKYCDataByWallet(wallet_);
        return data.status;
    }
}
