import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const KompoundModule = buildModule("KompoundModule", (m) => {
  // Deploy mock Compound core contracts
  const mockComptroller = m.contract("MockComptroller", []);
  const mockPriceFeed = m.contract("MockPriceFeed", []);

  // First deploy mock tokens and cTokens for local testing
  const mockWBTC = m.contract("MockERC20", ["Wrapped Bitcoin", "WBTC", 8]);
  const mockCEth = m.contract("MockCEther", ["Compound Ether", "cETH"]);
  const mockCWBTC = m.contract("MockCERC20", ["Compound WBTC", "cWBTC"]);

  // Deploy our contracts with the mock addresses
  const compoundEth = m.contract("CompoundEth", [mockCEth]);

  const compoundErc20 = m.contract("CompoundErc20", [
    mockWBTC,
    mockCWBTC,
    mockComptroller,
    mockPriceFeed,
  ]);

  const compoundLong = m.contract("CompoundLong", [
    mockCEth,
    mockCWBTC,
    mockWBTC,
    8, // WBTC decimals,
    mockComptroller,
    mockPriceFeed,
  ]);

  const compoundLiquidator = m.contract("CompoundLiquidator", [
    mockWBTC,
    mockCWBTC,
  ]);

  return {
    mockWBTC,
    mockCEth,
    mockCWBTC,
    mockComptroller,
    mockPriceFeed,
    compoundEth,
    compoundErc20,
    compoundLong,
    compoundLiquidator,
  };
});

export default KompoundModule;
