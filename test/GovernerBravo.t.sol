// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GovernorBravoDelegate.sol";
import "../src/GovernorBravoDelegator.sol";
import "../src/Timelock.sol";

interface IPollyToken {
    function unlockedSupply() external view returns (uint256);
    function totalLock() external view returns (uint256);
    function lockOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
    function mint(address account, uint256 amount) external;
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract CounterTest is Test {

    GovernorBravoDelegate delegate;

    GovernorBravoDelegator delegator;

    Timelock timelock;

    IPollyToken pollyToken;

    uint256 public polygonFork;

    string public rpc;
    
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
        rpc = vm.envString('POLYGON_RPC_URL');
        polygonFork = vm.createFork(rpc);
        delegate = new GovernorBravoDelegate();
        timelock = new Timelock(address(this), 2 days);
        pollyToken = IPollyToken(0x4C392822D4bE8494B798cEA17B43d48B2308109C);
        delegator = new GovernorBravoDelegator(address(timelock), address(pollyToken), address(this), address(delegate),  votingPeriod, votingDelay, proposalThreshold );
        
        uint256 eta = block.timestamp + 3 days;
        
        timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(address(delegator)), eta);
        
        skip(4 days);

        timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(address(delegator)), eta);
        
        (bool success2 ,) = address(delegator).call(abi.encodeWithSignature("_initiate()"));
        assertTrue(success2);
    }
    
    function testPropose() public {
        // Target addresses for proposal calls
        address[] memory targets = new address[](1);
        targets[0] = address(this);
        
        // Eth values for proposal calls
        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        // Function signatures for proposal calls
        string[] memory signatures = new string[](1);
        signatures[0] = "test()";

        // Calldata for proposal calls
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("test()");

        // Description of the proposal
        string memory description = "test proposal";
        
        GovernorBravoDelegate(address(delegator)).propose(targets, values, signatures, calldatas, description);
        
    }
}
