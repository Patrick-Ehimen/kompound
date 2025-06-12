// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/// @title IUniswapV2Pair Interface
/// @notice Interface for Uniswap V2 Pair contract, representing a liquidity pool for a pair of ERC20 tokens.
/// @dev Defines the standard functions and events for Uniswap V2 Pair contracts.
interface IUniswapV2Pair {
    // Events

    /// @notice Emitted when an approval is made for a spender by an owner.
    /// @param owner The address of the token owner.
    /// @param spender The address of the spender.
    /// @param value The amount approved.
    event Approval(address indexed owner, address indexed spender, uint value);

    /// @notice Emitted when a transfer of tokens occurs.
    /// @param from The address sending tokens.
    /// @param to The address receiving tokens.
    /// @param value The amount transferred.
    event Transfer(address indexed from, address indexed to, uint value);

    /// @notice Emitted when liquidity is minted.
    /// @param sender The address providing liquidity.
    /// @param amount0 Amount of token0 added.
    /// @param amount1 Amount of token1 added.
    event Mint(address indexed sender, uint amount0, uint amount1);

    /// @notice Emitted when liquidity is burned.
    /// @param sender The address burning liquidity.
    /// @param amount0 Amount of token0 withdrawn.
    /// @param amount1 Amount of token1 withdrawn.
    /// @param to The address receiving withdrawn tokens.
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    /// @notice Emitted when a swap occurs.
    /// @param sender The address initiating the swap.
    /// @param amount0In Amount of token0 input.
    /// @param amount1In Amount of token1 input.
    /// @param amount0Out Amount of token0 output.
    /// @param amount1Out Amount of token1 output.
    /// @param to The address receiving output tokens.
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );

    /// @notice Emitted when reserves are synced.
    /// @param reserve0 Reserve of token0.
    /// @param reserve1 Reserve of token1.
    event Sync(uint112 reserve0, uint112 reserve1);

    // Functions

    /// @notice Returns the name of the pair token.
    /// @return The name as a string.
    function name() external pure returns (string memory);

    /// @notice Returns the symbol of the pair token.
    /// @return The symbol as a string.
    function symbol() external pure returns (string memory);

    /// @notice Returns the number of decimals for the pair token.
    /// @return The decimals as uint8.
    function decimals() external pure returns (uint8);

    /// @notice Returns the total supply of liquidity tokens.
    /// @return The total supply as uint.
    function totalSupply() external view returns (uint);

    /// @notice Returns the balance of liquidity tokens for a given owner.
    /// @param owner The address to query.
    /// @return The balance as uint.
    function balanceOf(address owner) external view returns (uint);

    /// @notice Returns the remaining number of tokens that spender can spend on behalf of owner.
    /// @param owner The address of the token owner.
    /// @param spender The address of the spender.
    /// @return The allowance as uint.
    function allowance(address owner, address spender) external view returns (uint);

    /// @notice Approves a spender to spend a specified amount of tokens.
    /// @param spender The address to approve.
    /// @param value The amount to approve.
    /// @return True if the operation succeeded.
    function approve(address spender, uint value) external returns (bool);

    /// @notice Transfers tokens to a specified address.
    /// @param to The recipient address.
    /// @param value The amount to transfer.
    /// @return True if the operation succeeded.
    function transfer(address to, uint value) external returns (bool);

    /// @notice Transfers tokens from one address to another using allowance mechanism.
    /// @param from The address to transfer from.
    /// @param to The address to transfer to.
    /// @param value The amount to transfer.
    /// @return True if the operation succeeded.
    function transferFrom(address from, address to, uint value) external returns (bool);

    /// @notice Returns the EIP-712 domain separator.
    /// @return The domain separator as bytes32.
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /// @notice Returns the permit typehash used for EIP-2612 permits.
    /// @return The permit typehash as bytes32.
    function PERMIT_TYPEHASH() external pure returns (bytes32);

    /// @notice Returns the current nonce for an owner address (used for permits).
    /// @param owner The address to query.
    /// @return The current nonce as uint.
    function nonces(address owner) external view returns (uint);

    /// @notice Approves a spender via signature (EIP-2612).
    /// @param owner The address of the token owner.
    /// @param spender The address to approve.
    /// @param value The amount to approve.
    /// @param deadline The deadline timestamp for the permit.
    /// @param v The recovery byte of the signature.
    /// @param r Half of the ECDSA signature pair.
    /// @param s Half of the ECDSA signature pair.
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /// @notice Returns the minimum liquidity constant.
    /// @return The minimum liquidity as uint.
    function MINIMUM_LIQUIDITY() external pure returns (uint);

    /// @notice Returns the address of the factory contract that created this pair.
    /// @return The factory address.
    function factory() external view returns (address);

    /// @notice Returns the address of token0 in the pair.
    /// @return The address of token0.
    function token0() external view returns (address);

    /// @notice Returns the address of token1 in the pair.
    /// @return The address of token1.
    function token1() external view returns (address);

    /// @notice Returns the reserves of token0 and token1, and the last block timestamp.
    /// @return reserve0 Reserve of token0.
    /// @return reserve1 Reserve of token1.
    /// @return blockTimestampLast Last block timestamp when reserves were updated.
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    /// @notice Returns the last cumulative price of token0.
    /// @return The cumulative price as uint.
    function price0CumulativeLast() external view returns (uint);

    /// @notice Returns the last cumulative price of token1.
    /// @return The cumulative price as uint.
    function price1CumulativeLast() external view returns (uint);

    /// @notice Returns the last value of the product of reserves (k).
    /// @return The kLast value as uint.
    function kLast() external view returns (uint);

    /// @notice Mints liquidity tokens to the specified address.
    /// @param to The address to receive liquidity tokens.
    /// @return liquidity The amount of liquidity tokens minted.
    function mint(address to) external returns (uint liquidity);

    /// @notice Burns liquidity tokens and sends the underlying tokens to the specified address.
    /// @param to The address to receive the underlying tokens.
    /// @return amount0 Amount of token0 withdrawn.
    /// @return amount1 Amount of token1 withdrawn.
    function burn(address to) external returns (uint amount0, uint amount1);

    /// @notice Swaps tokens, sending output tokens to the specified address.
    /// @param amount0Out Amount of token0 to send out.
    /// @param amount1Out Amount of token1 to send out.
    /// @param to The address to receive output tokens.
    /// @param data Arbitrary data for flash swaps.
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    /// @notice Skims excess tokens to the specified address.
    /// @param to The address to receive excess tokens.
    function skim(address to) external;

    /// @notice Syncs the reserves to match the actual balances.
    function sync() external;

    /// @notice Initializes the pair with two token addresses (only callable by the factory).
    function initialize(address, address) external;
}