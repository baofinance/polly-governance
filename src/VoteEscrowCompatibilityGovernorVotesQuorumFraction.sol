// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

/// @author Bao Finance
abstract contract VoteEscrowCompatibilityGovernorVotesQuorumFraction is GovernorVotesQuorumFraction {
    constructor(uint256 quorumNumeratorValue) GovernorVotesQuorumFraction(quorumNumeratorValue) {}

    /**
     * @dev Returns the quorum for a timepoint, in terms of number of votes: `supply * numerator / denominator`.
     */
    function quorum(uint256 timepoint) public view virtual override returns (uint256) {
        (bool _success, bytes memory _data) = address(token).staticcall(abi.encodeWithSignature("totalSupplyAt(uint256)", timepoint));
        require(_success, "quorum: totalSupplyAt failed");
        return (abi.decode(_data, (uint256)) * quorumNumerator(timepoint)) / quorumDenominator();
    }
}