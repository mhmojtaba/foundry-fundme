// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";

pragma solidity ^0.8.18;

contract DeployFundme is Script {
    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundme = new FundMe(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.stopBroadcast();
        return fundme;
    }
}
