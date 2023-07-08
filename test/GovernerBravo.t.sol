// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GovernorBravoDelegate.sol";
import "../src/GovernorBravoDelegator.sol";
import "../src/PollyVotesMultiLP.sol";
import "../src/Timelock.sol";

contract CounterTest is Test {
    GovernorBravoDelegate delegate;
    GovernorBravoDelegator delegator;
    Timelock timelock;
    PollyVotesMultiLP pollyVotesMultiLP;

    /* The minimum number of votes required for an account to create a proposal.
    This can be changed through governance. */
    uint256 public proposalThreshold = 100000000000000000000000;

    /* The duration of voting on a proposal, in Ethereum blocks.
    This can be changed through governance. */
    uint256 public votingPeriod = 17280;

    /* The number of Ethereum blocks to wait before voting on a proposal may begin.
    This value is added to the current block number when a proposal is created.
    This can be changed through governance. */
    uint256 public votingDelay = 1;

    function setUp() public {
        delegate = new GovernorBravoDelegate();
        timelock = new Timelock(address(this), 2 days);
        pollyVotesMultiLP = PollyVotesMultiLP(0xDC997E70e48CE7a81f02a4701564a80FA801553E);
        delegator = new GovernorBravoDelegator(address(timelock), address(pollyVotesMultiLP), address(this), address(delegate), proposalThreshold, votingPeriod, votingDelay);
    }

    


}
