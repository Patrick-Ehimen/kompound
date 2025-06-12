// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/// @title IUniswapV2Factory
/// @notice Interface for the Uniswap V2 Factory contract, responsible for creating and managing trading pairs.
/// @dev This interface defines the core functions and events for the Uniswap V2 Factory.
interface IUniswapV2Factory {
    /// @notice Emitted when a new trading pair is created.
    /// @param token0 Address of the first token in the pair.
    /// @param token1 Address of the second token in the pair.
    /// @param pair Address of the newly created pair contract.
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    /// @notice Returns the address to which protocol fees are sent.
    /// @return The address receiving protocol fees.
    function feeTo() external view returns (address);

    /// @notice Returns the address allowed to set the feeTo address.
    /// @return The address with permission to set feeTo.
    function feeToSetter() external view returns (address);

    /// @notice Returns the address of the pair contract for two tokens, if it exists.
    /// @param tokenA Address of the first token.
    /// @param tokenB Address of the second token.
    /// @return pair The address of the pair contract, or address(0) if it does not exist.
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    /// @notice Returns the address of the pair contract at a given index.
    /// @param index The index of the pair in the list.
    /// @return pair The address of the pair contract.
    function allPairs(uint index) external view returns (address pair);

    /// @notice Returns the total number of pairs created by the factory.
    /// @return The total number of pairs.
    function allPairsLength() external view returns (uint);

    /// @notice Creates a new trading pair for two tokens if one does not already exist.
    /// @param tokenA Address of the first token.
    /// @param tokenB Address of the second token.
    /// @return pair The address of the newly created pair contract.
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    /// @notice Sets the address to which protocol fees are sent.
    /// @param _feeTo The address to receive protocol fees.
    function setFeeTo(address _feeTo) external;

    /// @notice Sets the address allowed to set the feeTo address.
    /// @param _feeToSetter The address with permission to set feeTo.
    function setFeeToSetter(address _feeToSetter) external;
}