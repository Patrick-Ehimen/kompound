// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/// @title IERC20 Interface
/// @notice Interface for the ERC20 standard as defined in the EIP
/// @dev This interface defines the standard functions and events for ERC20 tokens
interface IERC20 {
    /// @notice Returns the total token supply
    /// @return The total supply of tokens
    function totalSupply() external view returns (uint256);

    /// @notice Returns the account balance of another account with address _owner
    /// @param _owner The address of the account to query the balance of
    /// @return The balance of the specified address
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Transfers amount tokens to the specified address
    /// @param to The address to transfer to
    /// @param amount The amount to be transferred
    function transfer(address to, uint256 amount) external;

    /// @notice Returns the allowance of a spender on the owner's tokens
    /// @param from The address which owns the funds
    /// @param to The address which will spend the funds
    /// @param amount The amount to check allowance for
    /// @return True if the spender is allowed to spend the specified amount, false otherwise
    function allowance(
        address from,
        address to,
        uint256 amount
    ) external view returns (bool);

    /// @notice Approves the passed address to spend the specified amount of tokens on behalf of msg.sender
    /// @param sender The address which will spend the funds
    /// @param amount The amount of tokens to be spent
    function approve(address sender, uint256 amount) external;

    /// @notice Transfers tokens from one address to another using allowance mechanism
    /// @param from The address which you want to send tokens from
    /// @param to The address which you want to transfer to
    /// @param amount The amount of tokens to be transferred
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external;

    /// @notice Emitted when tokens are transferred, including zero value transfers
    /// @param from The address tokens are transferred from
    /// @param to The address tokens are transferred to
    /// @param amount The amount of tokens transferred
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// @notice Emitted when the approval amount for a spender is set by a call to approve
    /// @param from The address which owns the tokens
    /// @param to The address which will spend the tokens
    /// @param amount The amount of tokens approved
    event Approval(address indexed from, address indexed to, uint256 amount);
}