// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

import { ERC20 } from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import { DLTBase } from '../base/DLTBase.sol';
import { DEFAULT_ADMIN_ROLE } from '../common/Roles.sol';
import { DLTValidations } from '../lib/DLTValidations.sol';

/// @author DLT-Tools Team Team
/// @title DLT fake USDT tokens
contract DLTFakeUSDT is ERC20, DLTBase {
    uint256 private constant START_TOTAL_SUPPLY = 1000000000000000000000000000000;

    constructor(address dltConfig_) ERC20('DLTFakeUSDT', 'USDT') DLTBase(dltConfig_) {
        _mint(msg.sender, START_TOTAL_SUPPLY);
    }

    function mint(address to_, uint256 amount_) public onlyRole(DEFAULT_ADMIN_ROLE) {
        DLTValidations.validAddress(to_, 'to_');
        _mint(to_, amount_);
    }
}
