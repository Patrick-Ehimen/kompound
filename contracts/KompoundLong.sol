// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "./interfaces/IERC20.sol";
import {CErc20} from "./interfaces/compound/CErc20.sol";
import {Comptroller, PriceFeed} from "./interfaces/compound/Comptroller.sol";
import {CEth} from "./interfaces/compound/CEth.sol";
import {IUniswapV2Router} from "./interfaces/uniswap/IUniswapV2Router.sol";
import {IUniswapV2Pair} from "./interfaces/uniswap/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "./interfaces/uniswap/IUniswapV2Factory.sol";

contract CompoundLong {
    CEth public cEth;
    CErc20 public cTokenBorrow;
    IERC20 public tokenBorrow;
    uint public decimals;

    Comptroller public comptroller;

    PriceFeed public priceFeed;

    IUniswapV2Router private constant UNI =
        IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IERC20 private constant WETH =
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    constructor(
        address _cEth,
        address _cTokenBorrow,
        address _tokenBorrow,
        uint _decimals,
        address _comptroller,
        address _priceFeed
    ) {
        cEth = CEth(_cEth);
        cTokenBorrow = CErc20(_cTokenBorrow);
        tokenBorrow = IERC20(_tokenBorrow);
        decimals = _decimals;
        comptroller = Comptroller(_comptroller);
        priceFeed = PriceFeed(_priceFeed);

        // enter market to enable borrow
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cEth);
        uint[] memory errors = comptroller.enterMarkets(cTokens);
        require(errors[0] == 0, "Comptroller.enterMarkets failed.");
    }

    receive() external payable {}

    function supply() external payable {
        cEth.mint{value: msg.value}();
    }

    function getMaxBorrow() external view returns (uint) {
        (uint error, uint liquidity, uint shortfall) = comptroller
            .getAccountLiquidity(address(this));

        require(error == 0, "error");
        require(shortfall == 0, "shortfall > 0");
        require(liquidity > 0, "liquidity = 0");

        uint price = priceFeed.getUnderlyingPrice(address(cTokenBorrow));
        uint maxBorrow = (liquidity * (10**decimals)) / price;

        return maxBorrow;
    }

    function long(uint _borrowAmount) external {
        // borrow
        require(cTokenBorrow.borrow(_borrowAmount) == 0, "borrow failed");
        // buy ETH
        uint bal = tokenBorrow.balanceOf(address(this));
        tokenBorrow.approve(address(UNI), bal);

        address[] memory path = new address[](2);
        path[0] = address(tokenBorrow);
        path[1] = address(WETH);
        UNI.swapExactTokensForETH(bal, 1, path, address(this), block.timestamp);
    }

    function repay() external {
        // sell ETH
        address[] memory path = new address[](2);
        path[0] = address(WETH);
        path[1] = address(tokenBorrow);
        UNI.swapExactETHForTokens{value: address(this).balance}(
            1,
            path,
            address(this),
            block.timestamp
        );
        // repay borrow
        uint borrowed = cTokenBorrow.borrowBalanceCurrent(address(this));
        tokenBorrow.approve(address(cTokenBorrow), borrowed);
        require(cTokenBorrow.repayBorrow(borrowed) == 0, "repay failed");

        uint supplied = cEth.balanceOfUnderlying(address(this));
        require(cEth.redeemUnderlying(supplied) == 0, "redeem failed");

        // supplied ETH + supplied interest + profit (in token borrow)
    }

    function getSuppliedBalance() external returns (uint) {
        return cEth.balanceOfUnderlying(address(this));
    }

    function getBorrowBalance() external returns (uint) {
        return cTokenBorrow.borrowBalanceCurrent(address(this));
    }

    function getAccountLiquidity()
        external
        view
        returns (uint liquidity, uint shortfall)
    {
        // liquidity and shortfall in USD scaled up by 1e18
        (uint error, uint _liquidity, uint _shortfall) = comptroller
            .getAccountLiquidity(address(this));
        require(error == 0, "error");
        return (_liquidity, _shortfall);
    }
}
