// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (governance/extensions/GovernorVotes.sol)

pragma solidity ^0.8.19;

import {Governor} from "../lib/openzeppelin-contracts/contracts/governance/Governor.sol";
import {IVotes} from "../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import {IERC5805} from "../lib/openzeppelin-contracts/contracts/interfaces/IERC5805.sol";
import {SafeCast} from "../lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol";

/**
 * @dev Extension of {Governor} for voting weight extraction from an {ERC20Votes} token, or since v4.5 an {ERC721Votes} token.
 * @author Bao Finance
 */
abstract contract GovernorVotesCompatibilityGovernorBravo is Governor {
    IERC5805 public immutable token;

    constructor(IVotes tokenAddress) {
        token = IERC5805(address(tokenAddress));
    }

    /**
     * @dev Clock (as specified in EIP-6372) is set to match the token's clock. Fallback to block numbers if the token
     * does not implement EIP-6372.
     */
    function clock() public view virtual override returns (uint48) {
            return SafeCast.toUint48(block.number);
    }

    /**
     * @dev Machine-readable description of the clock as specified in EIP-6372.
     */
    // solhint-disable-next-line func-name-mixedcase
    function CLOCK_MODE() public view virtual override returns (string memory) {
            return "mode=blocknumber&from=default";
    }

    /**
     * Read the voting weight from the token's built in snapshot mechanism (see {Governor-_getVotes}).
     */
    function _getVotes(
        address account,
        uint256 timepoint,
        bytes memory /*params*/
    ) internal view virtual override returns (uint256) {
        (bool _success, bytes memory _data) = address(token).staticcall(abi.encodeWithSignature("balanceOfAt(address, uint256)", timepoint, account));
        require(_success, "quorum: totalSupplyAt failed");

        return abi.decode(_data, (uint256));
    }
}
