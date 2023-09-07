// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol";

/// @author Bao Finance
abstract contract GovernorVotesCompatibilityGovernorBravo is GovernorVotes {
    constructor(IVotes tokenAddress) GovernorVotes(tokenAddress) {

    }

    /**
     * @dev Returns the quorum for a timepoint, in terms of number of votes: `supply * numerator / denominator`.
     */
    function clock() public view virtual override returns (uint48) {
            return SafeCast.toUint48(block.number);
    }

    function CLOCK_MODE() public view virtual override returns (string memory) {
            return "mode=blocknumber&from=default";
    }
}