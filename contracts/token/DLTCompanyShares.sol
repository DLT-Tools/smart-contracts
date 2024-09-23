// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { ERC20 } from '@openzeppelin/contracts/token/ERC20/ERC20.sol';

/// @author DLT-Tools Team Team
/// @title DLT company shares contract
contract DLTCompanyShares is ERC20 {
    /// Fixed supply: 7.000.000.000 DLTCS
    /// Company capitalization: 7.000.000$
    /// Initial token price: 0,001$
    uint256 private constant COMPANY_CAPITALIZATION = 7000000000000000000000000000;

    constructor() ERC20('DLTCompanyShares', 'DLTCS') {
        _mint(msg.sender, COMPANY_CAPITALIZATION);
    }
}
