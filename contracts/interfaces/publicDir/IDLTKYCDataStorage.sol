// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IDLTStorage } from '../IDLTStorage.sol';
import { KYCData } from '../../models/publicDir/KYCData.sol';

/// @title IDLTKYCDataStorage
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTKYCDataStorage is IDLTStorage {
    function getLogicAddress() external view returns (address);

    function setData(KYCData memory data_) external;

    function removeData(uint256 id_) external;

    function getData(uint256 id_) external view returns (KYCData memory);

    function getIdByEmail(string memory email_) external view returns (uint256);

    function getIdByEmailHash(bytes32 emailHash_) external view returns (uint256);

    function getIdByWallet(address wallet_) external view returns (uint256);
}
