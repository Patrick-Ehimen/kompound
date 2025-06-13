// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockPriceFeed {
    mapping(address => uint) public prices;

    function setPrice(address asset, uint price) external {
        prices[asset] = price;
    }

    function getPrice(address asset) external view returns (uint) {
        return prices[asset];
    }
}
