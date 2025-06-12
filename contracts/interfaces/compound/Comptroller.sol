// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/// @title Comptroller Interface for Compound Protocol
/// @notice Interface for interacting with the Compound Comptroller contract
interface Comptroller {
    /**
     * @notice Returns information about a specific market
     * @param cToken The address of the cToken market
     * @return isListed Whether the market is listed
     * @return collateralFactorMantissa The collateral factor for the market (scaled by 1e18)
     * @return isComped Whether the market receives COMP rewards
     */
    function markets(address cToken)
        external
        view
        returns (
            bool isListed,
            uint collateralFactorMantissa,
            bool isComped
        );

    /**
     * @notice Enter the specified markets to enable them as collateral
     * @param cTokens The addresses of the cToken markets to enter
     * @return results Array of results for each entered market (0 = success, otherwise error code)
     */
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory results);

    /**
     * @notice Returns the account liquidity in terms of excess collateral or shortfall
     * @param account The address of the account to check
     * @return error Error code (0 = no error)
     * @return liquidity Account liquidity in excess of collateral requirements
     * @return shortfall Account shortfall below collateral requirements
     */
    function getAccountLiquidity(address account)
        external
        view
        returns (
            uint error,
            uint liquidity,
            uint shortfall
        );

    /**
     * @notice Returns the close factor mantissa used in liquidations
     * @return The close factor mantissa (scaled by 1e18)
     */
    function closeFactorMantissa() external view returns (uint);

    /**
     * @notice Returns the liquidation incentive mantissa
     * @return The liquidation incentive mantissa (scaled by 1e18)
     */
    function liquidationIncentiveMantissa() external view returns (uint);

    /**
     * @notice Calculates the number of collateral tokens to seize during liquidation
     * @param cTokenBorrowed The address of the borrowed cToken
     * @param cTokenCollateral The address of the collateral cToken
     * @param actualRepayAmount The amount of the underlying borrowed asset being repaid
     * @return error Error code (0 = no error)
     * @return seizeTokens The number of collateral tokens to seize
     */
    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint actualRepayAmount
    ) external view returns (uint error, uint seizeTokens);
}

/// @title PriceFeed Interface for Compound Protocol
/// @notice Interface for retrieving underlying asset prices from the Compound Price Feed
interface PriceFeed {
    /**
     * @notice Gets the price of the underlying asset for a given cToken
     * @param cToken The address of the cToken
     * @return price The price of the underlying asset (scaled by 1e18)
     */
    function getUnderlyingPrice(address cToken) external view returns (uint price);
}