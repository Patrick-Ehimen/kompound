// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "./interfaces/IERC20.sol";
import {CErc20} from "./interfaces/compound/CErc20.sol";
import {Comptroller, PriceFeed} from "./interfaces/compound/Comptroller.sol";
import {CEth} from "./interfaces/compound/CEth.sol";

/// @title CompoundErc20 Integration Contract
/// @notice This contract provides an interface to interact with Compound's cToken contracts for ERC20 tokens.
/// @dev Allows supplying, redeeming, borrowing, and repaying ERC20 tokens via Compound protocol.
/// @author 
contract CompoundErc20 {
    /// @notice The ERC20 token to be supplied/borrowed.
    IERC20 public token;

    /// @notice The corresponding cToken contract for the ERC20 token.
    CErc20 public cToken;

    /// @notice Comptroller contract for managing Compound protocol markets.
    Comptroller public comptroller;

    /// @notice Price feed contract for fetching underlying asset prices.
    PriceFeed public priceFeed;

    /// @param _token The address of the ERC20 token.
    /// @param _cToken The address of the corresponding cToken.
    /// @param _comptroller The address of the Comptroller contract.
    /// @param _priceFeed The address of the PriceFeed contract.
    constructor(address _token, address _cToken, address _comptroller, address _priceFeed) {
        token = IERC20(_token);
        cToken = CErc20(_cToken);
        comptroller = Comptroller(_comptroller);
        priceFeed = PriceFeed(_priceFeed);
    }

    /// @notice Supply ERC20 tokens to Compound and receive cTokens.
    /// @param _amount The amount of ERC20 tokens to supply.
  function supply(uint _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
        token.approve(address(cToken), _amount);
        require(cToken.mint(_amount) == 0, "mint failed");
    }

    /// @notice Get the cToken balance of this contract.
    /// @return The cToken balance.
    function getCTokenBalance() external view returns (uint) {
        return cToken.balanceOf(address(this));
    }

    /// @notice Get the current exchange rate and supply rate per block for the cToken.
    /// @return exchangeRate The current exchange rate.
    /// @return supplyRate The current supply rate per block.
   function getInfo() external returns (uint exchangeRate, uint supplyRate) {
        exchangeRate = cToken.exchangeRateCurrent();
        supplyRate = cToken.supplyRatePerBlock();
    }

    /// @notice Estimate the underlying token balance based on cToken balance and exchange rate.
    /// @dev Uses current exchange rate and assumes 8 decimals for WBTC.
    /// @return The estimated underlying token balance.
    function estimateBalanceOfUnderlying() external returns (uint) {
        uint cTokenBal = cToken.balanceOf(address(this));
        uint exchangeRate = cToken.exchangeRateCurrent();
        uint decimals = 8; // WBTC = 8 decimals
        uint cTokenDecimals = 8;

        return
            (exchangeRate * cTokenBal) / 10**(18 + decimals - cTokenDecimals);
    }

    /// @notice Get the actual underlying token balance by calling Compound's balanceOfUnderlying.
    /// @return The actual underlying token balance.
    function balanceOfUnderlying() external returns (uint) {
        return cToken.balanceOfUnderlying(address(this));
    }

    /// @notice Redeem cTokens for the underlying ERC20 tokens.
    /// @param _cTokenAmount The amount of cTokens to redeem.
    function redeem(uint _cTokenAmount) external {
        require(cToken.redeem(_cTokenAmount) == 0, "redeem failed");
    }

    /// @notice Get the collateral factor for the cToken market.
    /// @return The collateral factor (scaled by 1e18).
function getCollateralFactor() external view returns (uint) {
        (bool isListed, uint colFactor, bool isComped) = comptroller.markets(
            address(cToken)
        );

        return colFactor;
    }

    /// @notice Get the account liquidity and shortfall for this contract.
    /// @return liquidity The account liquidity in USD scaled by 1e18.
    /// @return shortfall The account shortfall in USD scaled by 1e18.
    function getAccountLiquidity()
        external
        view
        returns (uint liquidity, uint shortfall)
    {
        (uint error, uint _liquidity, uint _shortfall) = comptroller
            .getAccountLiquidity(address(this));

        require(error == 0, "error");

        return (_liquidity, _shortfall);
    }

    /// @notice Get the price of the underlying asset for a given cToken from the price feed.
    /// @param _cToken The address of the cToken.
    /// @return The price of the underlying asset (scaled by 1e18).
   function getPriceFeed(address _cToken) external view returns (uint) {
        return priceFeed.getUnderlyingPrice(_cToken);
    }

    /// @notice Borrow an asset from Compound using supplied collateral.
    /// @param _cTokenToBorrow The address of the cToken to borrow.
    /// @param _decimals The decimals of the underlying asset to borrow.
    function borrow(address _cTokenToBorrow, uint _decimals) external {
        address[] memory cTokens = new address[](1);

        cTokens[0] = address(cToken);

        uint[] memory errors = comptroller.enterMarkets(cTokens);
        require(errors[0] == 0, "error");

        (uint error, uint liquidity, uint shortfall) = comptroller
            .getAccountLiquidity(address(this));
        require(error == 0, "error");
        require(shortfall == 0, "account underwater");
        require(liquidity > 0, "liquidity = 0");

        uint price = priceFeed.getUnderlyingPrice(_cTokenToBorrow);

        uint maxBorrow = (liquidity * (10**_decimals)) / price;
        require(maxBorrow > 0, "max borrow = 0");

        uint amount = (maxBorrow * 50) / 100;

        require(CErc20(_cTokenToBorrow).borrow(amount) == 0, "borrow failed");
    }

    /// @notice Get the current borrowed balance for a given cToken.
    /// @param _cTokenBorrowed The address of the cToken borrowed.
    /// @return The current borrowed balance.
   function getBorrowedBalance(address _cTokenBorrowed) public returns (uint) {
        return CErc20(_cTokenBorrowed).borrowBalanceCurrent(address(this));
    }

    /// @notice Get the current borrow rate per block for a given cToken.
    /// @param _cTokenBorrowed The address of the cToken borrowed.
    /// @return The borrow rate per block.
    function getBorrowRatePerBlock(address _cTokenBorrowed)
        external
        view
        returns (uint)
    {
        return CErc20(_cTokenBorrowed).borrowRatePerBlock();
    }

    /// @notice Repay borrowed tokens to Compound.
    /// @param _tokenBorrorowed The address of the ERC20 token borrowed.
    /// @param _cTokenBorrowed The address of the cToken borrowed.
    /// @param _amount The amount to repay.
    function repay(
        address _tokenBorrorowed,
        address _cTokenBorrowed,
        uint _amount
    ) external {
        IERC20(_tokenBorrorowed).approve(_cTokenBorrowed, _amount);
        require(
            CErc20(_cTokenBorrowed).repayBorrow(_amount) == 0,
            "repay failed"
        );
    }
}
