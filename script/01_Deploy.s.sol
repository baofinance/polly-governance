// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Script.sol";
import "../src/PollyGovernor.sol";
import "../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import "../lib/openzeppelin-contracts/contracts/governance/TimelockController.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Deploy is Script {

    PollyGovernor public pollyGovernor;
    TimelockController public timelockController;
    IVotes public vePolly = IVotes(0x6200e9DD633f4E979e9EC46753Af1FB30db17956);

    address[] public proposers = [0x60FF4545C6e674fD182990F7A66143002Fa3A03C, 0xA849456125301De7DedA49c09a65B673C115Cf37];
    address public admin = 0x60FF4545C6e674fD182990F7A66143002Fa3A03C;

    function run() public {
        vm.startBroadcast();

        // Deploy Timelock Controller
        timelockController = new TimelockController(17280, proposers, proposers, admin);
        console2.log("Timelock Controller deployed at:", address(timelockController));

        // Deploy Governor
        pollyGovernor = new PollyGovernor(vePolly, timelockController);
        console2.log("Governor deployed at:", address(pollyGovernor));

        vm.stopBroadcast();
    }
}
