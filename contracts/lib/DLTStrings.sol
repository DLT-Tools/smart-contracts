// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

library DLTStrings {
    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function toBytes(bytes32 _data) public pure returns (bytes memory) {
        return abi.encodePacked(_data);
    }

    function iToHex(bytes32 buffer) public pure returns (string memory) {
        bytes memory bytesMemory = toBytes(buffer);
        return iToHex(bytesMemory);
    }

    function iToHex(bytes memory buffer) public pure returns (string memory) {
        // Fixed buffer size for hexadecimal convertion
        bytes memory converted = new bytes(buffer.length * 2);

        bytes memory _base = '0123456789abcdef';

        for (uint256 i = 0; i < buffer.length; i++) {
            converted[i * 2] = _base[uint8(buffer[i]) / _base.length];
            converted[i * 2 + 1] = _base[uint8(buffer[i]) % _base.length];
        }

        return string(abi.encodePacked('0x', converted));
    }

    function concatenate(uint256 number, string memory extension) public pure returns (string memory) {
        return string(abi.encodePacked(uint2str(number), extension));
    }

    function concatenateStrings(string memory a, string memory b, string memory c) public pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return '0';
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        while (_i != 0) {
            bstr[--length] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }

    function generateHash(string memory value_) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(value_));
    }
}
