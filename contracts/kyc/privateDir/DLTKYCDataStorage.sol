// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { EnumerableSet } from '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import { KYCData } from '../../models/privateDir/KYCData.sol';
import { KYCRequest } from '../../models/privateDir/KYCRequest.sol';
import { KYCTuple } from '../../models/privateDir/KYCTuple.sol';
import { DLTBase } from '../../base/DLTBase.sol';
import { IDLTConfig } from '../../interfaces/privateDir/IDLTConfig.sol';
import { IDLTKYCDataStorage } from '../../interfaces/privateDir/IDLTKYCDataStorage.sol';

contract DLTKYCDataStorage is IDLTKYCDataStorage, DLTBase {
    using EnumerableSet for EnumerableSet.UintSet;

    mapping(address => uint256) private _idByWallet;
    mapping(string => uint256) private _idByEmail;
    mapping(uint256 => KYCData) _data;
    mapping(uint256 => string[]) private _images;
    uint256 private _idCounter;
    EnumerableSet.UintSet private _allIds;
    mapping(uint256 => KYCRequest) _requests;

    modifier onlyLogicContract() {
        require(msg.sender == getLogicAddress(), 'DLTKYCDataStorage: Only logic contract can access');
        _;
    }

    constructor(address dltConfig_) DLTBase(dltConfig_) {}

    function getLogicAddress() public view returns (address) {
        return IDLTConfig(dltConfig).getDLTKYCDataLogic();
    }

    function setData(uint256 requestId_, KYCData memory data_) external onlyLogicContract whenNotPaused {
        _data[requestId_] = data_;
        if (!_allIds.contains(requestId_)) {
            _allIds.add(requestId_);
        }
        if (data_.wallet != address(0)) {
            _idByWallet[data_.wallet] = requestId_;
        }
        if (bytes(_data[requestId_].email).length > 0) {
            _idByEmail[data_.email] = requestId_;
        }
    }

    function removeData(uint256 requestId_) external onlyLogicContract whenNotPaused {
        require(_data[requestId_].id == requestId_, 'DLTKYCDataStorage: KYC data does not exist');
        // Reset key relations
        if (_data[requestId_].wallet != address(0)) {
            _idByWallet[_data[requestId_].wallet] = 0;
        } else if (bytes(_data[requestId_].email).length > 0) {
            _idByEmail[_data[requestId_].email] = 0;
        }
        // Remove data
        delete _data[requestId_];
        _allIds.remove(requestId_);
        delete _images[requestId_]; // Also remove associated images
        delete _requests[requestId_]; // Also remove associated request
    }

    function getData(uint256 requestId_) public view returns (KYCData memory) {
        return _data[requestId_];
    }

    function getDataByIds(uint256[] memory requestIds_) public view returns (KYCData[] memory) {
        KYCData[] memory data = new KYCData[](requestIds_.length);
        for (uint i = 0; i < requestIds_.length; i++) {
            data[i] = _data[requestIds_[i]];
        }
        return data;
    }

    function getRequestsByIds(uint256[] memory requestIds_) public view returns (KYCRequest[] memory) {
        KYCRequest[] memory requests = new KYCRequest[](requestIds_.length);
        for (uint i = 0; i < requestIds_.length; i++) {
            requests[i] = _requests[requestIds_[i]];
        }
        return requests;
    }

    function getByIds(uint256[] memory requestIds_) public view returns (KYCData[] memory, KYCRequest[] memory) {
        KYCData[] memory data = getDataByIds(requestIds_);
        KYCRequest[] memory requests = getRequestsByIds(requestIds_);
        return (data, requests);
    }

    function getTuplesByIds(uint256[] memory requestIds_) public view returns (KYCTuple[] memory) {
        KYCTuple[] memory items = new KYCTuple[](requestIds_.length);
        for (uint i = 0; i < requestIds_.length; i++) {
            items[i].request = _requests[requestIds_[i]];
            items[i].data = _data[requestIds_[i]];
        }
        return items;
    }

    function getNumData() public view returns (uint256) {
        return _allIds.length();
    }

    function getAllDataRange(uint256 start, uint256 maxSize) public view returns (uint256[] memory) {
        uint256 arrayLength = _allIds.length();

        if (start >= arrayLength) {
            return new uint256[](0);
        }

        uint256 size = (start + maxSize > arrayLength) ? arrayLength - start : maxSize;

        uint256[] memory ids = new uint256[](size);

        for (uint256 i = 0; i < size; i++) {
            ids[i] = _allIds.at(start + i);
        }
        return ids;
    }

    function incrementIdCounter() external onlyLogicContract whenNotPaused {
        _idCounter++;
    }

    function getIdCounter() external view returns (uint256) {
        return _idCounter;
    }

    function addImage(uint256 requestId_, string memory imageUrl_) external onlyLogicContract whenNotPaused {
        _images[requestId_].push(imageUrl_);
    }

    function setImage(
        uint256 requestrequestId_,
        uint256 imageIndex_,
        string memory imageUrl_
    ) external onlyLogicContract whenNotPaused {
        _images[requestrequestId_][imageIndex_] = imageUrl_;
    }

    function setImages(uint256 requestId_, string[] memory images_) external onlyLogicContract whenNotPaused {
        _images[requestId_] = images_;
    }

    function removeImage(uint256 requestId_, uint256 imageIndex_) external onlyLogicContract whenNotPaused {
        require(imageIndex_ < _images[requestId_].length, 'DLTKYCDataStorage: Invalid image index');

        if (imageIndex_ == _images[requestId_].length - 1) {
            _images[requestId_].pop();
        } else {
            _images[requestId_][imageIndex_] = _images[requestId_][_images[requestId_].length - 1];
            _images[requestId_].pop();
        }
    }

    function getImage(uint256 requestId_, uint256 imageIndex_) external view returns (string memory) {
        return _images[requestId_][imageIndex_];
    }

    function getImages(uint256 requestId_) external view returns (string[] memory) {
        return _images[requestId_];
    }

    function getIdByEmail(string memory email_) external view returns (uint256) {
        return _idByEmail[email_];
    }

    function getIdByWallet(address wallet_) external view returns (uint256) {
        return _idByWallet[wallet_];
    }

    function setRequest(uint256 requestId_, KYCRequest memory request_) external onlyLogicContract whenNotPaused {
        _requests[requestId_] = request_;
    }

    function getRequest(uint256 requestId_) external view returns (KYCRequest memory) {
        return _requests[requestId_];
    }
}
