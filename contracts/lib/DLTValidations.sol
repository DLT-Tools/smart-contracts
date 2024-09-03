// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { DLTStrings } from '../lib/DLTStrings.sol';
import { IERC721 } from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import { IDLTConfig } from '../interfaces/publicDir/IDLTConfig.sol';

library DLTValidations {
    function _checkIsValidYear(uint256 year_) internal pure returns (bool) {
        bool isValid;
        if (year_ >= 2024 && year_ <= 3000) {
            isValid = true;
        } else {
            isValid = false;
        }
        return isValid;
    }

    function validStringArray(string[] memory arr_, string memory nameParameter_) public pure {
        // Check if we have any element
        if (arr_.length == 0) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: The array must have at least one element. (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function validDate(uint256 day_, string memory nameParameter_) public pure {
        _checkDate(day_, nameParameter_);
    }

    function validAddress(address account_, string memory nameParameter_) public pure {
        _checkAddress(account_, nameParameter_);
    }

    function _checkDate(uint256 day_, string memory nameParameter_) internal pure {
        bool isCorrectDate = day_ % 1 days == 0;
        if (!isCorrectDate) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: Incorrect datetime format, it should be 0 after module 86400 seconds (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function validContract(address contractAddress_, string memory nameParameter_) public view {
        _checkAddress(contractAddress_, nameParameter_);
        bool isContract = _isContract(contractAddress_);
        if (!isContract) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: This address is not smart contract (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function _checkAddress(address account_, string memory nameParameter_) internal pure {
        if (account_ == address(0)) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: zero address is not allowed (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function _isContract(address addr) internal view returns (bool) {
        uint256 size;
        // Inline assembly to retrieve the size of the code on target address.
        assembly {
            size := extcodesize(addr)
        }
        // If the size is greater than zero, the address is a contract.
        return size > 0;
    }

    function validNFTTokenId(address contractAddress_, uint256 tokenId_, string memory nameParameter_) public view {
        bool tokenExists = _checkNFTTokenId(contractAddress_, tokenId_);
        if (!tokenExists) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: Token with this id not exists (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function _checkNFTTokenId(address nftContract_, uint256 tokenId_) internal view returns (bool) {
        bool nftTokenHasOwner;
        try IERC721(nftContract_).ownerOf(tokenId_) returns (address) {
            nftTokenHasOwner = true;
        } catch {
            nftTokenHasOwner = false;
        }
        // If NFT Token has owner, is the same to say token exists
        return nftTokenHasOwner;
    }

    function validString(string memory str_, string memory nameParameter_) public pure {
        _checkString(str_, nameParameter_);
    }

    function _checkString(string memory str_, string memory nameParameter_) internal pure {
        if (bytes(str_).length == 0) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: is not allowed empty string (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function validWallet(address walletAddress_, string memory nameParameter_) public view {
        _checkAddress(walletAddress_, nameParameter_);
        bool isContract = _isContract(walletAddress_);
        if (isContract) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: This address is smart contract (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }

    function validHash(bytes32 hash_, string memory nameParameter_) public pure {
        _checkHash(hash_, nameParameter_);
    }

    function _checkHash(bytes32 hash_, string memory nameParameter_) internal pure {
        if (hash_ == bytes32(0)) {
            string memory errorMessage = DLTStrings.concatenateStrings(
                'DLTValidations: Invalid hash, because is bytes32(0) (',
                nameParameter_,
                ')'
            );
            revert(errorMessage);
        }
    }
}
