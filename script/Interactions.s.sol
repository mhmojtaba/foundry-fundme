// SPDX-License-Identifier: MIT

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

pragma solidity ^0.8.18;

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundme(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("fund me fund", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);

        fundFundme(mostRecentlyDeployed);
    }
}

contract WithdrawFundme {}
