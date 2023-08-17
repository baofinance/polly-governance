// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Script.sol";
import "../src/PollyGovernor.sol";
import "../src/ERC1967Proxy.sol";
import "../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import "../lib/openzeppelin-contracts/contracts/governance/TimelockController.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Deploy is Script {

    PollyGovernor public pollyGovernor;
    TimelockController public timelockController;
    address public pollyToken;
    IVotes public vePolly = IVotes(0xCbAEC82448DAE09418bCd78Bf7654CB9De5a9D8d);

    function run() public {
        vm.startBroadcast();

        address[] memory proposers = new address[](1);
        proposers[0] = address(this);

        // Deploy Timelock Controller
        timelockController = new TimelockController(17280, proposers, proposers, address(this));
        console2.log("Timelock Controller deployed at:", address(timelockController));

        // Deploy Governor
        pollyGovernor = new PollyGovernor(vePolly, timelockController);
        console2.log("Governor deployed at:", address(pollyGovernor));

        vm.stopBroadcast();
    }
}
