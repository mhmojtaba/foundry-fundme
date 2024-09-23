// SPDX-License-Identifier: MIT

import {getPrice} from "./getPrice.sol";

pragma solidity ^0.8.18;

contract FundMe {
    // using library for getting price and convert it to usd
    using getPrice for uint256; // data enhance for value

    address immutable owner;
    uint256 public constant MINIMUN_AMOUNT = 10 * 1e18; //10.000000000000000000 $

    address[] public funders;
    mapping(address => uint256) funds;

    event NewFunder(address indexed funder, uint256 amountETH, uint256 amountUsd, uint256 gas);
    event withdrawLog(uint256 amountETH, uint256 amountUsd);

    constructor(address _owner) {
        owner = _owner;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function fund() external payable {
        require(msg.value.getPriceInUsd() >= MINIMUN_AMOUNT, "less than minimum amount");
        funders.push(msg.sender);
        funds[msg.sender] += msg.value;
        emit NewFunder(msg.sender, msg.value, msg.value.getPriceInUsd() / 1e16, gasleft()); // with 2 decimals
    }

    // everyone can refund the amount that funded before
    // refund must be done before withdraw
    function refund() external {
        require(funds[msg.sender] > 0, "You don't have enough funds to refund");
        (bool success,) = owner.call{value: funds[msg.sender]}("");
        require(success, "refund process failed");
        funds[msg.sender] = 0;
    }

    function getFunds(address _founder) external view returns (uint256) {
        return funds[_founder];
    }

    function getFunders() external view returns (address[] memory) {
        return funders;
    }

    function withdraw() external OnlyOwner {
        require(funders.length > 0, "there is no founders");
        // change value of funders to zero
        uint256 fundersLength = funders.length; // reading the length of array to use in loop (gas optimizing)
        for (uint256 index = 0; index < fundersLength; index++) {
            address funder = funders[index];
            funds[funder] = 0;
        }
        // reset the array of funders
        funders = new address[](0);
        uint256 contractBalance = address(this).balance;
        emit withdrawLog(contractBalance, contractBalance.getPriceInUsd() / 1e16); // with 2 decimals
        (bool success,) = owner.call{value: contractBalance}("");
        require(success, "withdraw failed");
    }

    receive() external payable {}
    fallback() external payable {}
}
