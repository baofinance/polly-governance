// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Script.sol";
import "../src/PollyGovernor.sol";
import "../src/ERC1967Proxy.sol";
import "../src/VPolly.sol";
import "../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import "../lib/openzeppelin-contracts/contracts/governance/TimelockController.sol";

contract Deploy is Script {

    PollyGovernor public pollyGovernor;
    TimelockController public timelockController;
    address public pollyToken;
    VPolly public vPolly;

    address public testnetPolly = 0xC0adF78641409093cfc59D4b88b8c83394803489;
    address public mainnetPolly = 0x4C392822D4bE8494B798cEA17B43d48B2308109C;

    function run() public {
        vm.startBroadcast();

        pollyToken = 0xC0adF78641409093cfc59D4b88b8c83394803489;

        // Deploy VPolly
        vPolly = new VPolly(IERC20(pollyToken));
        console2.log("VPolly deployed at:", address(vPolly));

        address[] memory proposers = new address[](1);
        proposers[0] = address(this);

        // Deploy Timelock Controller
        timelockController = new TimelockController(17280, proposers, proposers, address(this));
        console2.log("Timelock Controller deployed at:", address(timelockController));

        // Deploy Governor
        pollyGovernor = new PollyGovernor(vPolly, timelockController);
        console2.log("Governor deployed at:", address(pollyGovernor));

        vm.stopBroadcast();
    }
}
