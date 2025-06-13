// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/// @title IUniswapV2Router Interface
/// @notice Interface for Uniswap V2 Router functions for token swaps and liquidity management
interface IUniswapV2Router {
    /**
     * @notice Returns the amounts of output tokens for a given input amount and path.
     * @param amountIn The amount of input tokens.
     * @param path An array of token addresses representing the swap path.
     * @return amounts An array of output amounts for each step in the path.
     */
     function getAmountsOut(uint amountIn, address[] memory path)
        external
        view
        returns (uint[] memory amounts);
    
    /**
     * @notice Swaps an exact amount of input tokens for as many output tokens as possible, along the specified path.
     * @param amountIn The amount of input tokens to send.
     * @param amountOutMin The minimum amount of output tokens that must be received for the transaction not to revert.
     * @param path An array of token addresses representing the swap path.
     * @param to Recipient address of the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts An array of output amounts for each step in the path.
     */
        function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    /**
     * @notice Swaps an exact amount of input tokens for as much ETH as possible, along the specified path.
     * @param amountIn The amount of input tokens to send.
     * @param amountOutMin The minimum amount of ETH that must be received for the transaction not to revert.
     * @param path An array of token addresses representing the swap path.
     * @param to Recipient address of the ETH.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts An array of output amounts for each step in the path.
     */
        function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    /**
     * @notice Swaps an exact amount of ETH for as many output tokens as possible, along the specified path.
     * @param amountOutMin The minimum amount of output tokens that must be received for the transaction not to revert.
     * @param path An array of token addresses representing the swap path.
     * @param to Recipient address of the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amounts An array of output amounts for each step in the path.
     */
        function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
    
    /**
     * @notice Adds liquidity to a token pair pool.
     * @param tokenA Address of token A.
     * @param tokenB Address of token B.
     * @param amountADesired Amount of token A to add.
     * @param amountBDesired Amount of token B to add.
     * @param amountAMin Minimum amount of token A to add (slippage protection).
     * @param amountBMin Minimum amount of token B to add (slippage protection).
     * @param to Recipient address of the liquidity tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amountA Actual amount of token A added.
     * @return amountB Actual amount of token B added.
     * @return liquidity Amount of liquidity tokens minted.
     */
        function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    )
        external
        returns (
            uint amountA,
            uint amountB,
            uint liquidity
        );
    
    /**
     * @notice Removes liquidity from a token pair pool.
     * @param tokenA Address of token A.
     * @param tokenB Address of token B.
     * @param liquidity Amount of liquidity tokens to burn.
     * @param amountAMin Minimum amount of token A to receive (slippage protection).
     * @param amountBMin Minimum amount of token B to receive (slippage protection).
     * @param to Recipient address of the withdrawn tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @return amountA Amount of token A received.
     * @return amountB Amount of token B received.
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
}
