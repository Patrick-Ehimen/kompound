// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function exitMarket(address cToken) external returns (uint);
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral, address cTokenBorrowed) external returns (uint);
}

contract MockComptroller is ComptrollerInterface {
    uint public constant NO_ERROR = 0;

    mapping(address => bool) public markets;
    mapping(address => uint) public exitMarketErrors;

    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory) {
        uint[] memory result = new uint[](cTokens.length);
        for (uint i = 0; i < cTokens.length; i++) {
            markets[cTokens[i]] = true;
            result[i] = NO_ERROR;
        }
        return result;
    }

    function exitMarket(address cToken) external returns (uint) {
        require(markets[cToken], "not in market");
        delete markets[cToken];
        return exitMarketErrors[cToken];
    }

    function setExitMarketError(address cToken, uint error) external {
        exitMarketErrors[cToken] = error;
    }

    function getAccountLiquidity(address account) external view returns (uint, uint, uint) {
        return (NO_ERROR, 1000 ether, 100 ether);
    }

    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral, address cTokenBorrowed) external returns (uint) {
        return NO_ERROR;
    }
}
