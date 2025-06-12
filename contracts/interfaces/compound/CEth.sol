// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;
/// @title CEth Interface for Compound Protocol
/// @notice Interface for interacting with the Compound cETH contract
/// @dev This interface defines the essential functions for minting, redeeming, borrowing, and repaying ETH in the Compound protocol
interface CEth {
    /// @notice Get the cETH balance of a specific address
    /// @param account The address to query the balance of
    /// @return The cETH token balance of the address
    function balanceOf(address account) external view returns (uint);

    /// @notice Mint cETH by supplying ETH to the contract
    function mint() external payable;

    /// @notice Get the current exchange rate from cETH to ETH
    /// @return The current exchange rate scaled by 1e18
    function exchangeRateCurrent() external returns (uint);

    /// @notice Get the current supply interest rate per block
    /// @return The current supply rate per block (scaled by 1e18)
    function supplyRatePerBlock() external returns (uint);

    /// @notice Get the underlying ETH balance for a specific address
    /// @param account The address to query the underlying balance of
    /// @return The underlying ETH balance of the address
    function balanceOfUnderlying(address account) external returns (uint);

    /// @notice Redeem a specified amount of cETH for the underlying ETH
    /// @param redeemTokens The number of cETH tokens to redeem
    /// @return 0 on success, otherwise an error code
    function redeem(uint redeemTokens) external returns (uint);

    /// @notice Redeem cETH for a specified amount of underlying ETH
    /// @param redeemAmount The amount of ETH to redeem
    /// @return 0 on success, otherwise an error code
    function redeemUnderlying(uint redeemAmount) external returns (uint);

    /// @notice Borrow a specified amount of ETH from the protocol
    /// @param borrowAmount The amount of ETH to borrow
    /// @return 0 on success, otherwise an error code
    function borrow(uint borrowAmount) external returns (uint);

    /// @notice Get the current borrow balance for a specific address
    /// @param account The address to query the borrow balance of
    /// @return The current borrow balance of the address (including interest)
    function borrowBalanceCurrent(address account) external returns (uint);

    /// @notice Get the current borrow interest rate per block
    /// @return The current borrow rate per block (scaled by 1e18)
    function borrowRatePerBlock() external view returns (uint);

    /// @notice Repay the borrower's entire outstanding borrow balance with ETH
    function repayBorrow() external payable;
}