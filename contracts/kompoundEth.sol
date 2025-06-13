// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "./interfaces/IERC20.sol";
import {CErc20} from "./interfaces/compound/CErc20.sol";
import {Comptroller, PriceFeed} from "./interfaces/compound/Comptroller.sol";
import {CEth} from "./interfaces/compound/CEth.sol";

/// @title CompoundEth - A contract to interact with Compound's cETH token
/// @notice This contract allows users to supply ETH to Compound, check balances, and redeem cETH
/// @dev Interacts with a CEth contract interface. Assumes CEth interface is defined elsewhere.
/// @author 
contract CompoundEth {
    /// @notice The cETH token contract instance
    CEth public cToken;

    /// @notice Initializes the contract with the address of the cETH token
    /// @param _cToken The address of the deployed cETH contract
   constructor(address _cToken) {
        cToken = CEth(address(_cToken));
    }

    /// @notice Fallback function to receive ETH
    receive() external payable {}

    /// @notice Supplies ETH to Compound and mints cETH tokens
    /// @dev The amount of ETH sent with the transaction will be supplied
    function supply() external payable {
        cToken.mint{value: msg.value}();
    }

    /// @notice Returns the cETH token balance of this contract
    /// @return The cETH token balance
    function getCTokenBalance() external view returns (uint) {
        return cToken.balanceOf(address(this));
    }

    /// @notice Gets the current exchange rate and supply rate per block from the cETH contract
    /// @dev Calls exchangeRateCurrent() and supplyRatePerBlock() on the cETH contract
    /// @return exchangeRate The current exchange rate from cETH to ETH
    /// @return supplyRate The current supply rate per block
    function getInfo() external returns (uint exchangeRate, uint supplyRate) {
        // Amount of current exchange rate from cToken to underlying
        exchangeRate = cToken.exchangeRateCurrent();
        // Amount added to you supply balance this block
        supplyRate = cToken.supplyRatePerBlock();
    }

    /// @notice Estimates the balance of underlying ETH based on cETH balance and current exchange rate
    /// @dev Uses current exchange rate and cETH balance to estimate underlying ETH
    /// @return The estimated underlying ETH balance
   function estimateBalanceOfUnderlying() external returns (uint) {
        uint cTokenBal = cToken.balanceOf(address(this));
        uint exchangeRate = cToken.exchangeRateCurrent();
        uint decimals = 18; // DAI = 18 decimals
        uint cTokenDecimals = 8;

        return
            (cTokenBal * exchangeRate) / 10**(18 + decimals - cTokenDecimals);
    }

    /// @notice Returns the actual balance of underlying ETH by calling cToken.balanceOfUnderlying
    /// @return The actual underlying ETH balance
    function balanceOfUnderlying() external returns (uint) {
        return cToken.balanceOfUnderlying(address(this));
    }

    /// @notice Redeems a specified amount of cETH tokens for the underlying ETH
    /// @param _cTokenAmount The amount of cETH tokens to redeem
    /// @dev Reverts if the redeem operation fails
    function redeem(uint _cTokenAmount) external {
        require(cToken.redeem(_cTokenAmount) == 0, "redeem failed");
        // cToken.redeemUnderlying(underlying amount);
    }
}
