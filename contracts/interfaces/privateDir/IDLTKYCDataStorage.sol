// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { IDLTStorage } from '../IDLTStorage.sol';
import { KYCData } from '../../models/privateDir/KYCData.sol';
import { KYCRequest } from '../../models/privateDir/KYCRequest.sol';
import { KYCTuple } from '../../models/privateDir/KYCTuple.sol';

/// @title IDLTKYCDataStorage
/// @author DLT-Tools Team
/// @custom:security-contact support@beruwa.la
interface IDLTKYCDataStorage is IDLTStorage {
    function setData(uint256 requestId, KYCData memory data) external;

    function removeData(uint256 requestId) external;

    function getData(uint256 requestId) external view returns (KYCData memory);

    function getDataByIds(uint256[] memory requestIds) external view returns (KYCData[] memory);

    function getRequestsByIds(uint256[] memory requestIds) external view returns (KYCRequest[] memory);

    function getByIds(uint256[] memory requestIds) external view returns (KYCData[] memory, KYCRequest[] memory);

    function getTuplesByIds(uint256[] memory requestIds) external view returns (KYCTuple[] memory);

    function getNumData() external view returns (uint256);

    function getAllDataRange(uint256 start, uint256 maxSize) external view returns (uint256[] memory);

    function incrementIdCounter() external;

    function getIdCounter() external view returns (uint256);

    function addImage(uint256 requestId, string memory imageUrl) external;

    function setImage(uint256 requestId, uint256 imageIndex, string memory imageUrl) external;

    function setImages(uint256 requestId, string[] memory images) external;

    function removeImage(uint256 requestId, uint256 imageIndex) external;

    function getImage(uint256 requestId, uint256 imageIndex) external view returns (string memory);

    function getImages(uint256 requestId) external view returns (string[] memory);

    function getIdByEmail(string memory email) external view returns (uint256);

    function getIdByWallet(address wallet) external view returns (uint256);

    function setRequest(uint256 requestId, KYCRequest memory request) external;

    function getRequest(uint256 requestId) external view returns (KYCRequest memory);
}
