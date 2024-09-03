// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { KYCData } from '../../models/publicDir/KYCData.sol';
import { DLTBase } from '../../base/DLTBase.sol';
import { IDLTConfig } from '../../interfaces/publicDir/IDLTConfig.sol';
import { IDLTKYCDataStorage } from '../../interfaces/publicDir/IDLTKYCDataStorage.sol';
import { DLTStrings } from '../../lib/DLTStrings.sol';

contract DLTKYCDataStorage is IDLTKYCDataStorage, DLTBase {
    mapping(address => uint256) private _idByWallet;
    mapping(bytes32 => uint256) private _idByEmailHash;
    mapping(uint256 => KYCData) _data;

    modifier onlyLogicContract() {
        require(msg.sender == getLogicAddress(), 'DLTKYCDataStorage: Only logic contract can access');
        _;
    }

    constructor(address dltConfig_) DLTBase(dltConfig_) {}

    function getLogicAddress() public view returns (address) {
        return IDLTConfig(dltConfig).getDLTKYCDataLogic();
    }

    function setData(KYCData calldata data_) external onlyLogicContract whenNotPaused {
        uint256 requestId = data_.id;
        _data[requestId] = data_;
        if (data_.wallet != address(0)) {
            _idByWallet[data_.wallet] = requestId;
        }
        if (_data[requestId].emailHash != bytes32(0)) {
            _idByEmailHash[data_.emailHash] = requestId;
        }
    }

    function removeData(uint256 id_) external onlyLogicContract whenNotPaused {
        require(_data[id_].id == id_, 'DLTKYCDataStorage: KYC data does not exist');
        // Reset key relations
        if (_data[id_].wallet != address(0)) {
            _idByWallet[_data[id_].wallet] = 0;
        } else if (_data[id_].emailHash != bytes32(0)) {
            _idByEmailHash[_data[id_].emailHash] = 0;
        }
        // Remove data
        delete _data[id_];
    }

    function getData(uint256 id_) public view returns (KYCData memory) {
        return _data[id_];
    }

    function getIdByEmail(string memory email_) external view returns (uint256) {
        bytes32 emailHash = DLTStrings.generateHash(email_);
        return _idByEmailHash[emailHash];
    }

    function getIdByEmailHash(bytes32 emailHash_) external view returns (uint256) {
        return _idByEmailHash[emailHash_];
    }

    function getIdByWallet(address wallet_) external view returns (uint256) {
        return _idByWallet[wallet_];
    }
}
