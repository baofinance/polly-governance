// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Wrapper.sol";

contract VPolly is ERC20, ERC20Permit, ERC20Votes, ERC20Wrapper {
    constructor(
        IERC20 wrappedToken
    ) ERC20("VPolly", "VPLY") ERC20Permit("VPolly") ERC20Wrapper(wrappedToken) {}

    // The functions below are overrides required by Solidity.

    function decimals() public view virtual override(ERC20, ERC20Wrapper) returns (uint8) {
        return super.decimals();
    }

    function nonces(address owner) public view virtual override(Nonces, ERC20Permit) returns (uint256) {
        return super.nonces(owner);
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes){
        super._update(from, to, value);
    }
}