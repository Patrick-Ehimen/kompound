const { ethers, network } = require("hardhat");
const { expect } = require("chai");
require("dotenv").config();

describe("CompoundErc20", function () {
  let accounts: any[],
    mockToken: any,
    mockCToken: any,
    mockComptroller: any,
    mockPriceFeed: any,
    compoundErc20: any,
    fundAmount: bigint,
    tokenDecimals: number;

  beforeEach(async function () {
    accounts = await ethers.getSigners();
    fundAmount = 1000n * 10n ** 18n; // 1000 tokens
    tokenDecimals = 18;

    // Deploy Mock Contracts
    const MockERC20 = await ethers.getContractFactory("MockERC20");
    mockToken = await await MockERC20.deploy(
      "Mock Token",
      "MTK",
      tokenDecimals
    );
    await mockToken.waitForDeployment();
    const mockTokenAddress = await mockToken.getAddress();

    const MockCERC20 = await ethers.getContractFactory("MockCERC20");
    mockCToken = await await MockCERC20.deploy("Mock cToken", "cMTK");
    await mockCToken.waitForDeployment();
    const mockCTokenAddress = await mockCToken.getAddress();

    const MockComptroller = await ethers.getContractFactory("MockComptroller");
    mockComptroller = await await MockComptroller.deploy();
    await mockComptroller.waitForDeployment();
    const mockComptrollerAddress = await mockComptroller.getAddress();

    const MockPriceFeed = await ethers.getContractFactory("MockPriceFeed");
    mockPriceFeed = await await MockPriceFeed.deploy();
    await mockPriceFeed.waitForDeployment();
    const mockPriceFeedAddress = await await mockPriceFeed.getAddress();

    // Deploy CompoundErc20 contract
    const CompoundErc20 = await ethers.getContractFactory("CompoundErc20");
    compoundErc20 = await (
      await CompoundErc20.deploy(
        mockTokenAddress,
        mockCTokenAddress,
        mockComptrollerAddress,
        mockPriceFeedAddress
      )
    ).waitForDeployment();

    // Fund account[1] with mock tokens
    await mockToken.mint(accounts[1].address, fundAmount);

    // Approve CompoundErc20 contract to spend tokens
    await mockToken
      .connect(accounts[1])
      .approve(compoundErc20.address, fundAmount);
  });

  it("should supply tokens to Compound", async function () {
    const supplyAmount = 100n * 10n ** 18n;
    await compoundErc20.connect(accounts[1]).supply(supplyAmount);

    // Check token balance of CompoundErc20 contract
    const tokenBalance = await mockToken.balanceOf(compoundErc20.address);
    expect(tokenBalance).to.equal(supplyAmount);

    // Check cToken balance of CompoundErc20 contract
    const cTokenBalance = await mockCToken.balanceOf(compoundErc20.address);
    expect(cTokenBalance).to.equal(0); // Minting in MockCERC20 is not implemented

    // Check cToken balance of user
    const userCTokenBalance = await mockCToken.balanceOf(accounts[1].address);
    expect(userCTokenBalance).to.equal(0);
  });

  it("should get cToken balance", async function () {
    const supplyAmount = 100n * 10n ** 18n;
    await compoundErc20.connect(accounts[1]).supply(supplyAmount);

    const cTokenBalance = await compoundErc20.getCTokenBalance();
    expect(cTokenBalance).to.equal(0); // Minting in MockCERC20 is not implemented
  });

  it("should get exchange rate and supply rate", async function () {
    const { exchangeRate, supplyRate } = await compoundErc20.getInfo();
    expect(exchangeRate).to.equal(0); // MockCERC20 does not implement exchangeRate
    expect(supplyRate).to.equal(0); // MockCERC20 does not implement supplyRate
  });

  it("should estimate balance of underlying", async function () {
    const supplyAmount = 100n * 10n ** 18n;
    await compoundErc20.connect(accounts[1]).supply(supplyAmount);

    const estimatedBalance = await compoundErc20.estimateBalanceOfUnderlying();
    expect(estimatedBalance).to.equal(0); // MockCERC20 does not implement exchangeRate
  });

  it("should get balance of underlying", async function () {
    const supplyAmount = 100n * 10n ** 18n;
    await compoundErc20.connect(accounts[1]).supply(supplyAmount);

    const underlyingBalance = await compoundErc20.balanceOfUnderlying();
    expect(underlyingBalance).to.equal(0); // MockCERC20 does not implement balanceOfUnderlying
  });

  it("should redeem cTokens", async function () {
    const supplyAmount = 100n * 10n ** 18n;
    await compoundErc20.connect(accounts[1]).supply(supplyAmount);

    const cTokenAmount = 10n * 10n ** 18n;
    await expect(compoundErc20.redeem(cTokenAmount)).to.be.revertedWith(
      "redeem failed"
    ); // redeem will fail since MockCERC20 does not implement redeem
  });

  it("should get collateral factor", async function () {
    const collateralFactor = await compoundErc20.getCollateralFactor();
    expect(collateralFactor).to.equal(0); // MockComptroller returns 0
  });

  it("should get account liquidity", async function () {
    const { liquidity, shortfall } = await compoundErc20.getAccountLiquidity();
    expect(liquidity).to.equal(1000); // MockComptroller returns 1000 ethers
    expect(shortfall).to.equal(100); // MockComptroller returns 100 ethers
  });

  it("should get price feed", async function () {
    // Set a mock price
    const mockPrice = 1000n * 10n ** 18n;
    await mockPriceFeed.setPrice(mockToken.address, mockPrice);

    const price = await compoundErc20.getPriceFeed(mockToken.address);
    expect(price).to.equal(0); // MockPriceFeed does not implement getUnderlyingPrice
  });

  it("should borrow tokens", async function () {
    // Set a mock price
    const mockPrice = 1000n * 10n ** 18n;
    await mockPriceFeed.setPrice(mockToken.address, mockPrice);

    const borrowAmount = 10n * 10n ** 18n;
    await expect(
      compoundErc20.borrow(mockToken.address, tokenDecimals)
    ).to.be.revertedWith("error"); // borrow will fail since MockCERC20 does not implement borrow
  });

  it("should get borrowed balance", async function () {
    const borrowedBalance = await compoundErc20.getBorrowedBalance(
      mockToken.address
    );
    expect(borrowedBalance).to.equal(0); // MockCERC20 does not implement borrowBalanceCurrent
  });

  it("should get borrow rate per block", async function () {
    const borrowRate = await compoundErc20.getBorrowRatePerBlock(
      mockToken.address
    );
    expect(borrowRate).to.equal(0); // MockCERC20 does not implement borrowRatePerBlock
  });

  it("should repay borrowed tokens", async function () {
    const repayAmount = 10n * 10n ** 18n;
    await expect(
      compoundErc20.repay(mockToken.address, mockCToken.address, repayAmount)
    ).to.be.revertedWith("repay failed"); // repay will fail since MockCERC20 does not implement repayBorrow
  });
});
