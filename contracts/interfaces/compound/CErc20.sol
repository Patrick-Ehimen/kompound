// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/// @title CErc20 Interface for Compound Protocol
/// @notice Interface for interacting with Compound's cERC20 tokens
interface CErc20 {
    /// @notice Gets the balance of cTokens for a specific account
    /// @param account The address of the account
    /// @return The number of cTokens owned by the account
    function balanceOf(address account) external view returns (uint);

    /// @notice Mints cTokens by supplying an underlying asset to the protocol
    /// @param mintAmount The amount of the underlying asset to supply
    /// @return 0 on success, otherwise an error code
    function mint(uint mintAmount) external returns (uint);

    /// @notice Gets the current exchange rate from the cToken to the underlying asset
    /// @return The current exchange rate scaled by 1e18
    function exchangeRateCurrent() external returns (uint);

    /// @notice Gets the current supply interest rate per block
    /// @return The current supply rate per block (scaled by 1e18)
    function supplyRatePerBlock() external returns (uint);

    /// @notice Gets the underlying balance of an account including interest accrued
    /// @param account The address of the account
    /// @return The amount of underlying asset owned by the account
    function balanceOfUnderlying(address account) external returns (uint);

    /// @notice Redeems a specified number of cTokens in exchange for the underlying asset
    /// @param redeemTokens The number of cTokens to redeem
    /// @return 0 on success, otherwise an error code
    function redeem(uint redeemTokens) external returns (uint);

    /// @notice Redeems cTokens in exchange for a specified amount of underlying asset
    /// @param redeemAmount The amount of underlying asset to redeem
    /// @return 0 on success, otherwise an error code
    function redeemUnderlying(uint redeemAmount) external returns (uint);

    /// @notice Borrows a specified amount of the underlying asset from the protocol
    /// @param borrowAmount The amount of the underlying asset to borrow
    /// @return 0 on success, otherwise an error code
    function borrow(uint borrowAmount) external returns (uint);

    /// @notice Gets the current borrow balance of an account including interest accrued
    /// @param account The address of the account
    /// @return The amount of underlying asset borrowed by the account
    function borrowBalanceCurrent(address account) external returns (uint);

    /// @notice Gets the current borrow interest rate per block
    /// @return The current borrow rate per block (scaled by 1e18)
    function borrowRatePerBlock() external view returns (uint);

    /// @notice Repays a borrow on the protocol
    /// @param repayAmount The amount of the underlying asset to repay
    /// @return 0 on success, otherwise an error code
    function repayBorrow(uint repayAmount) external returns (uint);

    /// @notice Liquidates a borrower's collateral
    /// @param borrower The address of the borrower to liquidate
    /// @param repayAmount The amount of the underlying borrowed asset to repay
    /// @param cTokenCollateral The address of the cToken to seize as collateral
    /// @return 0 on success, otherwise an error code
    function liquidateBorrow(
        address borrower,
        uint repayAmount,
        address cTokenCollateral
    ) external returns (uint);
}