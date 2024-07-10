// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

// Based on https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
interface IERC20Full is IERC20 {
    // Methods
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}
