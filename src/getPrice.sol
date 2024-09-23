// SPDX-License-Identifier: MIT

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

pragma solidity ^0.8.18;

// library get price
library getPrice {
    function getETHPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // Chainlink Price Feed Address for ETH / USD
        (, int256 price,,,) = priceFeed.latestRoundData(); // Gets the latest price of ETH / USD in Chainlink Price Feed
        return uint256(price) * 1e10; // convert decimal to 18
    } // 3436.386630600000000000 $

    function getPriceInUsd(uint256 amount /* wei amount*/ ) public view returns (uint256) {
        // Converts Amount of ETH to USD
        return (amount * getETHPrice()) / 1e18;
    }
}
