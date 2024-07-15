// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

library DLTStrings {
    function bytes32ToString(bytes32 bytes32_) public pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && bytes32_[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && bytes32_[i] != 0; i++) {
            bytesArray[i] = bytes32_[i];
        }
        return string(bytesArray);
    }

    function toBytes(bytes32 data_) public pure returns (bytes memory) {
        return abi.encodePacked(data_);
    }

    function iToHex(bytes32 buffer_) public pure returns (string memory) {
        bytes memory bytesMemory = toBytes(buffer_);
        return iToHex(bytesMemory);
    }

    function iToHex(bytes memory buffer_) public pure returns (string memory) {
        // Fixed buffer size for hexadecimal convertion
        bytes memory converted = new bytes(buffer_.length * 2);

        bytes memory _base = '0123456789abcdef';

        for (uint256 i = 0; i < buffer_.length; i++) {
            converted[i * 2] = _base[uint8(buffer_[i]) / _base.length];
            converted[i * 2 + 1] = _base[uint8(buffer_[i]) % _base.length];
        }

        return string(abi.encodePacked('0x', converted));
    }

    function concatenate(uint256 number_, string memory extension_) public pure returns (string memory) {
        return string(abi.encodePacked(uint2str(number_), extension_));
    }

    function concatenateStrings(string memory a_, string memory b_, string memory c_) public pure returns (string memory) {
        return string(abi.encodePacked(a_, b_, c_));
    }

    function uint2str(uint256 i_) internal pure returns (string memory) {
        if (i_ == 0) {
            return '0';
        }
        uint256 j = i_;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        while (i_ != 0) {
            bstr[--length] = bytes1(uint8(48 + (i_ % 10)));
            i_ /= 10;
        }
        return string(bstr);
    }

    function generateHash(string memory value_) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(value_));
    }

    function addressToString(address address_) public pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(address_)));
        bytes memory alphabet = '0123456789abcdef';

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }
}
