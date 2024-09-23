// SPDX-License-Identifier: MIT

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {DeployFundme} from "../../script/FundmeDeploy.s.sol";

pragma solidity ^0.8.18;

contract FundmeTest is Test {
    FundMe fundme;
    address public owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() external {
        // fundme = new FundMe(owner);
        DeployFundme deployFundme = new DeployFundme();
        fundme = deployFundme.run();
    }

    function test_miniAmount() public view {
        assertEq(fundme.MINIMUN_AMOUNT(), 10 * 1e18);
    }
}
